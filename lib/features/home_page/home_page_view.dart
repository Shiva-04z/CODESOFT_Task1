import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:to_do_list/features/home_page/home_page_controller.dart';
import '../../models/task.dart';

class HomePageView extends GetView<HomePageController> {
  Widget taskView(Task task, BuildContext context) {
    final bool isOverdue = task.endDate.isBefore(DateTime.now()) &&
        task.status != "Completed";
    final bool isCompleted = task.status == "Completed";
    final Color statusColor = _getStatusColor(task);
    final Color bgColor = statusColor.withOpacity(0.1);
    final bool isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 16,
        vertical: 8,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 16 : 18,
                    color: Colors.grey[800],
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isOverdue)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 6 : 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    "OVERDUE",
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: isSmallScreen ? 9 : 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          childrenPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          collapsedBackgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: bgColor,
          iconColor: Colors.grey[600],
          collapsedIconColor: Colors.grey[600],
          children: [
            _buildDateRow(task, context),
            SizedBox(height: isSmallScreen ? 8 : 12),
            _buildDescription(task, context),
            SizedBox(height: isSmallScreen ? 12 : 16),
            _buildActionButtons(task, isCompleted, context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Task task, bool isCompleted, BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 400;
    final double buttonSpacing = isSmallScreen ? 4 : 8;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 350) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isCompleted)
                _buildCompleteButton(task, isSmallScreen, true),
              if (!isCompleted) SizedBox(height: buttonSpacing),
              Row(
                children: [
                  Expanded(child: _buildEditButton(task, isSmallScreen, true)),
                  SizedBox(width: buttonSpacing),
                  Expanded(child: _buildDeleteButton(task, isSmallScreen, true)),
                ],
              ),
            ],
          );
        } else {
          return Wrap(
            alignment: WrapAlignment.end,
            spacing: buttonSpacing,
            runSpacing: buttonSpacing,
            children: [
              if (!isCompleted)
                _buildCompleteButton(task, isSmallScreen, false),
              _buildEditButton(task, isSmallScreen, false),
              _buildDeleteButton(task, isSmallScreen, false),
            ],
          );
        }
      },
    );
  }

  Widget _buildCompleteButton(Task task, bool isSmallScreen, bool isVertical) {
    return OutlinedButton.icon(
      onPressed: () => controller.markTaskComplete(task),
      icon: Icon(Icons.check_circle, size: isSmallScreen ? 16 : 18),
      label: isVertical || !isSmallScreen
          ? Text("Complete", style: TextStyle(fontSize: isSmallScreen ? 12 : 14))
          : SizedBox(),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.green,
        side: BorderSide(color: Colors.green),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: isSmallScreen
            ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : null,
      ),
    );
  }

  Widget _buildEditButton(Task task, bool isSmallScreen, bool isVertical) {
    return OutlinedButton.icon(
      onPressed: () => controller.editTaskDescription(task),
      icon: Icon(Icons.edit, size: isSmallScreen ? 16 : 18),
      label: isVertical || !isSmallScreen
          ? Text("Edit", style: TextStyle(fontSize: isSmallScreen ? 12 : 14))
          : SizedBox(),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        side: BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: isSmallScreen
            ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : null,
      ),
    );
  }

  Widget _buildDeleteButton(Task task, bool isSmallScreen, bool isVertical) {
    return OutlinedButton.icon(
      onPressed: () => controller.removeTask(task),
      icon: Icon(Icons.delete, size: isSmallScreen ? 16 : 18),
      label: isVertical || !isSmallScreen
          ? Text("Delete", style: TextStyle(fontSize: isSmallScreen ? 12 : 14))
          : SizedBox(),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: isSmallScreen
            ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : null,
      ),
    );
  }

  Widget _buildDateRow(Task task, BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: _buildDateChip(
            icon: Icons.play_arrow,
            date: task.startDate,
            color: Colors.blue,
            isSmallScreen: isSmallScreen,
          ),
          onTap: ()=>controller.editTaskStartDate(task),

        ),
        Icon(Icons.arrow_forward,
            color: Colors.grey,
            size: isSmallScreen ? 32 : 48),
        InkWell(
          onTap: ()=>controller.editTaskEndDate(task),
          child: _buildDateChip(
            icon: Icons.flag,
            date: task.endDate,
            color: Colors.orange,
            isSmallScreen: isSmallScreen,
          ),
        ),
      ],
    );
  }

  Widget _buildDateChip({
    required IconData icon,
    required DateTime date,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Chip(
      avatar: Icon(icon, size: isSmallScreen ? 14 : 16, color: color),
      label: Text(
        "${controller.twoDigits(date.day)}-${controller.twoDigits(date.month)}-${date.year}",
        style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
      ),
      backgroundColor: color.withOpacity(0.1),
      shape: StadiumBorder(
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      padding: isSmallScreen
          ? EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : null,
    );
  }

  Widget _buildDescription(Task task, BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        task.description,
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
          color: Colors.grey[700],
          height: 1.4,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Color _getStatusColor(Task task) {
    if (task.status == "Completed") return Colors.green;
    if (task.status == "Working") return Colors.orange;
    if (task.endDate.isBefore(DateTime.now())) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Tasks",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 20 : 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.taskList.isEmpty) {
            return _buildEmptyState(isSmallScreen);
          }
          return RefreshIndicator(
            onRefresh: () async {
              // Add refresh functionality if needed
            },
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 8,
                bottom: isSmallScreen ? 72 : 80,
              ),
              itemBuilder: (context, index) {
                final Task task = controller.taskList[controller.taskList.length - index - 1];
                return taskView(task, context);
              },
              itemCount: controller.taskList.length,
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showAddTaskDialog(),
        backgroundColor: Colors.blue[700],
        elevation: 2,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: isSmallScreen ? 24 : 28,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: isSmallScreen ? 56 : 64,
            color: Colors.blue[200],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            "No Tasks Yet",
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Tap the + button to add your first task",
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}