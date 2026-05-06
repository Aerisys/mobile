import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/themes/app_colors.dart';
import '../../../data/models/dashboard_widget_model.dart';
import '../../../data/models/drone_model.dart';
import '../view_models/dashboard_view_model.dart';
import '../components/atoms/aerisys_icon.dart';
import '../components/atoms/dashed_border_painter.dart';
import '../components/molecules/drone_preview.dart';
import '../components/organisms/widget_picker_sheet.dart';

class EditWidgetsPage extends StatelessWidget {
  const EditWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app we might get the drone from a ViewModel.
    final activeDrone = DroneModel(
      id: '1',
      name: 'Super drone 30000',
      modelType: 'DJI Mavic',
      batteryLevel: 85,
      status: 'Connecté',
    );

    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const AerisysIcon(Icons.close, color: AppColors.darkSlate, size: 24),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      activeDrone.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkSlate,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.brandBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const AerisysIcon(Icons.check, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                child: Column(
                  children: [
                    DronePreview(drone: activeDrone),
                    const SizedBox(height: 30),

                    // Top Slot (Full width)
                    _buildTopSlot(context, viewModel),
                    const SizedBox(height: 16),

                    // Small slots (3 columns)
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return _buildSmallSlot(context, viewModel, index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSlot(BuildContext context, DashboardViewModel viewModel) {
    final type = viewModel.topSlot;
    if (type == null) {
      return GestureDetector(
        onTap: () async {
          final selectedType = await WidgetPickerSheet.show(context);
          if (selectedType != null) {
            viewModel.setTopSlot(selectedType);
          }
        },
        child: CustomPaint(
          painter: DashedBorderPainter(color: Colors.grey.withValues(alpha: 0.3), radius: 20),
          child: Container(
            height: 100,
            width: double.infinity,
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                shape: BoxShape.circle,
              ),
              child: const AerisysIcon(Icons.add, color: Colors.grey, size: 24),
            ),
          ),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkSlate,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
            onTap: () async {
              final selectedType = await WidgetPickerSheet.show(context);
              if (selectedType != null) {
                viewModel.setTopSlot(selectedType);
              } else {
                viewModel.removeTopSlot();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                ],
              ),
              child: const AerisysIcon(Icons.edit, color: Colors.grey, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallSlot(BuildContext context, DashboardViewModel viewModel, int index) {
    final type = viewModel.smallSlots[index];

    if (type == null) {
      return GestureDetector(
        onTap: () async {
          final selectedType = await WidgetPickerSheet.show(context);
          if (selectedType != null) {
            viewModel.setSmallSlot(index, selectedType);
          }
        },
        child: CustomPaint(
          painter: DashedBorderPainter(color: Colors.grey.withValues(alpha: 0.3), radius: 20),
          child: Container(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                shape: BoxShape.circle,
              ),
              child: const AerisysIcon(Icons.add, color: Colors.grey, size: 24),
            ),
          ),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F7F9),
                  shape: BoxShape.circle,
                ),
                child: AerisysIcon(type.icon, color: AppColors.darkSlate, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                type.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkSlate,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
            onTap: () async {
              final selectedType = await WidgetPickerSheet.show(context);
              if (selectedType != null) {
                viewModel.setSmallSlot(index, selectedType);
              } else {
                viewModel.removeSmallSlot(index);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                ],
              ),
              child: const AerisysIcon(Icons.edit, color: Colors.grey, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}
