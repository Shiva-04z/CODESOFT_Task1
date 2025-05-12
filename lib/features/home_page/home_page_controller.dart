import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/models/task.dart';


class HomePageController extends GetxController {
  late Box<Task> taskBox;
  RxList<Task> taskList = <Task>[].obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  @override
  void onInit() async {
    super.onInit();
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    taskBox = await Hive.openBox<Task>('tasks');
    taskList.addAll(taskBox.values.toList());
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String? titleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a valid Title";
    }
    return null;
  }

  String? descriptionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a valid Description";
    }
    return null;
  }

  Future<void> pickStartDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? now,
      firstDate: now,
      lastDate: DateTime(2400),
    );
    if (picked != null) startDate.value = picked;
  }

  Future<void> pickEndDate(BuildContext context) async {
    final first = startDate.value ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? first,
      firstDate: first,
      lastDate: DateTime(2400),
    );
    if (picked != null) endDate.value = picked;
  }

  void showAddTaskDialog() {
    titleController.clear();
    descriptionController.clear();
    startDate.value = null;
    endDate.value = null;

    Get.dialog(
      AlertDialog(
        title: Text(
          "Add New Task",textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,

            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: EdgeInsets.only(left: 8,right: 8,top:12,bottom: 5),
        backgroundColor: Colors.blue[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: SingleChildScrollView(
          child: Obx(
                () => Container(
                  width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(8),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      validator: titleValidator,
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      validator: descriptionValidator,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    _buildDatePickerTile(
                      "Start Date",
                      startDate.value,
                          () => pickStartDate(Get.context!),
                      Icons.calendar_today,
                    ),
                    SizedBox(height: 8),
                    _buildDatePickerTile(
                      "End Date",
                      endDate.value,
                          () => pickEndDate(Get.context!),
                      Icons.calendar_today,
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: Text("Cancel",style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed:(){ _validateAndAddTask();Get.back();},
                          child: Text("Add Task",style: TextStyle(color: Colors.white)),
                        ),
                      ],

                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child:Container(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: Text("Done",style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerTile(
      String label, DateTime? date, VoidCallback onTap, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        date == null
            ? "Select $label"
            : "$label: ${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}",
        style: TextStyle(
          color: date == null ? Colors.grey : Colors.black87,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      onTap: onTap,
    );
  }

  void _validateAndAddTask() {
    if (formKey.currentState!.validate() &&
        startDate.value != null &&
        endDate.value != null) {
      if (!endDate.value!.isAfter(startDate.value!)) {
        Get.snackbar(
          "Error",
          "End date must be after start date",
          backgroundColor: Colors.red,
          colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
        );
        return;

      }

      final newTask = Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        startDate: startDate.value!,
        endDate: endDate.value!,
        status: startDate.value!.isAfter(DateTime.now()) ? "Pending" : "Working",
      );
      Get.snackbar(
        "Success",
        "Task added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,

      );
      taskList.add(newTask);
      taskBox.add(newTask);
      Get.back();
    } else {
      Get.snackbar(
        "Error",
        "Please fill all fields and select dates",
        backgroundColor: Colors.red,
        colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
      );



    }
  }

  void removeTask(Task task) {
    Get.snackbar(
        "Done",
        "Removed Sucessfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,

    );
    taskList.remove(task);
    taskBox.delete(task.key); // Remove from Hive
  }

  void editTaskDescription(Task task) {
    final descController = TextEditingController(text: task.description);

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.blue[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Edit Description",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: EdgeInsets.only(top:12,left:8,bottom:6,right:8),
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: descController,
                validator: descriptionValidator,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: Text("Cancel", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (descController.text.trim().isNotEmpty) {
                        task.description = descController.text.trim();
                         // Update Hive
                        Get.snackbar(
                          "Updated",
                          "Description updated successfully",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        taskList.refresh();
                        task.save();
                        Get.back();
                        Get.back();
                      } else {
                        Get.snackbar(
                          "Error",
                          "Description cannot be empty",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text("Update", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




  void editTaskEndDate(Task task) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: task.endDate,
      firstDate: task.startDate,
      lastDate: DateTime(2400),
    );

    if (picked != null) {
      if (picked.isBefore(task.startDate)) {
        Get.snackbar(
          "Invalid End Date",
          "End date cannot be before the start date.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      task.endDate = picked;
      task.status = task.startDate.isAfter(DateTime.now()) ? "Pending" : "Working";

      Get.snackbar(
        "Success",
        "End date updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      taskList.refresh();
      task.save();
    }
  }
  void editTaskStartDate(Task task) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: task.startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2400),
    );

    if (picked != null) {
      if (picked.isAfter(task.endDate)) {
        Get.snackbar(
          "Invalid Start Date",
          "Start date cannot be after the end date.",
          backgroundColor: Colors.red,
          colorText: Colors.white,

        );
        return;
      }

      task.startDate = picked;
      task.status = task.startDate.isAfter(DateTime.now()) ? "Pending" : "Working";



      Get.snackbar(
        "Success",
        "Start date updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      taskList.refresh();
      task.save();
    }
  }


  void markTaskComplete(Task task) {
    Get.snackbar(
      "Success",
      "Status updated successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    task.status = "Completed";
    taskList.refresh();
    task.save(); // Update in Hive
  }
}