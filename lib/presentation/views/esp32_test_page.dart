import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/usb_serial_service.dart';

/// Page de test de la connexion USB série avec l'ESP32.
/// À intégrer dans ton router existant.
///
/// Exemple :
///   Navigator.push(context, MaterialPageRoute(builder: (_) => const Esp32TestPage()));
class Esp32TestPage extends StatefulWidget {
  const Esp32TestPage({super.key});

  @override
  State<Esp32TestPage> createState() => _Esp32TestPageState();
}

class _Esp32TestPageState extends State<Esp32TestPage>
    with SingleTickerProviderStateMixin {
  final _service = UsbSerialService.instance;
  final List<_LogEntry> _logs = [];

  _Status _status = _Status.idle;
  StreamSubscription? _msgSub;
  StreamSubscription? _connSub;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    if (_service.isConnected) _status = _Status.connected;

    _msgSub = _service.messageStream.listen((msg) {
      _addLog(msg, incoming: true);
    });

    _connSub = _service.connectionStream.listen((connected) {
      if (mounted) {
        setState(() {
          _status = connected ? _Status.connected : _Status.idle;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _msgSub?.cancel();
    _connSub?.cancel();
    super.dispose();
  }

  void _addLog(String message, {bool incoming = false}) {
    if (!mounted) return;
    setState(() {
      _logs.insert(
        0,
        _LogEntry(text: message, incoming: incoming, time: TimeOfDay.now()),
      );
      if (_logs.length > 50) _logs.removeLast();
    });
  }

  Future<void> _toggleConnection() async {
    if (_status == _Status.connecting) return;

    if (_status == _Status.connected) {
      await _service.disconnect();
      _addLog('Déconnecté');
      return;
    }

    setState(() => _status = _Status.connecting);
    _addLog('Recherche ESP32…');

    final ok = await _service.connect();

    if (!mounted) return;
    if (ok) {
      _addLog('ESP32 connecté ✓', incoming: true);
    } else {
      setState(() => _status = _Status.idle);
      _addLog('Échec — vérifiez le câble OTG');
    }
  }

  Future<void> _sendPing() async {
    await _service.send('ping');
    _addLog('ping →');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF888888)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ESP32 / USB',
          style: TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFFEEEEEE),
            fontSize: 16,
            letterSpacing: 3,
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _StatusDot(status: _status, pulse: _pulseController),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(color: Color(0xFF222222), height: 1),

          // ── Panneau de contrôle ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatusCard(status: _status),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: _status == _Status.connected
                            ? 'DÉCONNECTER'
                            : 'CONNECTER',
                        loading: _status == _Status.connecting,
                        primary: _status != _Status.connected,
                        onTap: _toggleConnection,
                      ),
                    ),
                    if (_status == _Status.connected) ...[
                      const SizedBox(width: 12),
                      _ActionButton(
                        label: 'PING',
                        onTap: _sendPing,
                        primary: false,
                        small: true,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFF222222), height: 1),

          // ── Logs ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TERMINAL',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFF555555),
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                if (_logs.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _logs.clear()),
                    child: const Text(
                      'EFFACER',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFF444444),
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: _logs.isEmpty
                ? const Center(
                    child: Text(
                      '—',
                      style: TextStyle(color: Color(0xFF333333), fontSize: 24),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _logs.length,
                    itemBuilder: (_, i) => _LogLine(entry: _logs[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final _Status status;
  const _StatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        border: Border.all(color: status.borderColor, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(status.icon, color: status.color, size: 18),
          const SizedBox(width: 12),
          Text(
            status.label,
            style: TextStyle(
              fontFamily: 'monospace',
              color: status.color,
              fontSize: 13,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;
  final bool loading;
  final bool small;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.primary = true,
    this.loading = false,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: small ? 48 : 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary ? const Color(0xFF00E676) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(4),
          border: primary ? null : Border.all(color: const Color(0xFF333333)),
        ),
        child: loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF0D0D0D),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: primary
                      ? const Color(0xFF0D0D0D)
                      : const Color(0xFF888888),
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final _Status status;
  final AnimationController pulse;
  const _StatusDot({required this.status, required this.pulse});

  @override
  Widget build(BuildContext context) {
    if (status == _Status.connecting) {
      return AnimatedBuilder(
        animation: pulse,
        builder: (_, __) => Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              const Color(0xFFFF9800),
              const Color(0xFF333333),
              pulse.value,
            ),
          ),
        ),
      );
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: status.color),
    );
  }
}

class _LogLine extends StatelessWidget {
  final _LogEntry entry;
  const _LogLine({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${entry.time.hour.toString().padLeft(2, '0')}:${entry.time.minute.toString().padLeft(2, '0')} ',
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Color(0xFF444444),
              fontSize: 11,
            ),
          ),
          Text(
            entry.incoming ? '← ' : '→ ',
            style: TextStyle(
              fontFamily: 'monospace',
              color: entry.incoming
                  ? const Color(0xFF00E676)
                  : const Color(0xFF888888),
              fontSize: 11,
            ),
          ),
          Expanded(
            child: Text(
              entry.text,
              style: TextStyle(
                fontFamily: 'monospace',
                color: entry.incoming
                    ? const Color(0xFFCCCCCC)
                    : const Color(0xFF666666),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Modèles ──────────────────────────────────────────────────────────────────

class _LogEntry {
  final String text;
  final bool incoming;
  final TimeOfDay time;
  _LogEntry({required this.text, required this.incoming, required this.time});
}

enum _Status {
  idle,
  connecting,
  connected;

  String get label => switch (this) {
    idle => 'NON CONNECTÉ',
    connecting => 'CONNEXION EN COURS…',
    connected => 'ESP32 CONNECTÉ',
  };

  Color get color => switch (this) {
    idle => const Color(0xFF555555),
    connecting => const Color(0xFFFF9800),
    connected => const Color(0xFF00E676),
  };

  Color get borderColor => switch (this) {
    idle => const Color(0xFF222222),
    connecting => const Color(0xFF3D2B00),
    connected => const Color(0xFF003D1A),
  };

  IconData get icon => switch (this) {
    idle => Icons.usb_off,
    connecting => Icons.usb,
    connected => Icons.usb,
  };
}
