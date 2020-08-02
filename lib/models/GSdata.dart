class SliderModel {
  String imagePath;
  String title;
  String desc;

  SliderModel({this.imagePath, this.title, this.desc});

  void setImageAssetPath(String getImagepath) {
    imagePath = getImagepath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getTitle) {
    desc = getTitle;
  }

  String getImageAssetPath() {
    return imagePath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setImageAssetPath("assets/slide1.png");
  sliderModel.setTitle("");
  sliderModel.setDesc("");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setImageAssetPath("assets/slide2.png");
  sliderModel.setTitle("");
  sliderModel.setDesc("");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setImageAssetPath("assets/slide3.png");
  sliderModel.setTitle("");
  sliderModel.setDesc("");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
