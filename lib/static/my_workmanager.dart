enum MyWorkmanager {
  oneOff("task-identifier", "task-identifier"),
  periodic(
      "com.dianp.restauran_submission_1", "com.dianp.restauran_submission_1");

  final String uniqueName;
  final String taskName;

  const MyWorkmanager(this.uniqueName, this.taskName);
}
