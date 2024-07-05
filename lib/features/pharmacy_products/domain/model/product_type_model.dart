class MedicineData {
  final List<String> medicineForm;
  final List<String> medicinePackage;
  final List<String> equipmentType;
  final List<String> othersCategoryType;
  final List<String> othersPackage;
  final List<String> othersForm;
  MedicineData(
      {
        required this.equipmentType,
      required this.othersCategoryType,
     required this.othersPackage,
      required this.othersForm,
      required this.medicineForm,
      required this.medicinePackage});
}
