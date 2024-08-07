class PickerModel<T> {
  final String title;
  final List<T> selected;
  final List<T> data;

  PickerModel({
    this.title,
    this.selected,
    this.data,
  });
}
