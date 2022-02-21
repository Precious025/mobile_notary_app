class SliderModel {
  String? image;
  String? logo;
  String? description;

// Constructor for variables
  SliderModel({this.logo, this.description, this.image});

  void setImage(String? getImage) {
    image = getImage;
  }

  void setTitle(String? getLogo) {
    logo = getLogo;
  }

  void setDescription(String? getDescription) {
    description = getDescription;
  }

  String? getImage() {
    return image;
  }

  String? getLogo() {
    return logo;
  }

  String? getDescription() {
    return description;
  }
}

// List created
List<SliderModel> getSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel = SliderModel();

// Item 1
  sliderModel.setImage("assets/images/Car.png");
  sliderModel.setTitle("assets/images/Logo.png");
  sliderModel.setDescription(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.");
  slides.add(sliderModel);

  sliderModel = SliderModel();

// Item 2
  sliderModel.setImage("assets/images/map_logo.png");
  sliderModel.setTitle("assets/images/Logo.png");
  sliderModel.setDescription(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.");
  slides.add(sliderModel);

  sliderModel = SliderModel();

// Item 3
  sliderModel.setImage("assets/images/marked_car.png");
  sliderModel.setTitle("assets/images/Logo.png");
  sliderModel.setDescription(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.");
  slides.add(sliderModel);

  sliderModel = SliderModel();
  return slides;
}
