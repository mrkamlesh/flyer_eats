import 'package:flyereats/model/banner.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/food_category.dart';
import 'package:flyereats/model/order.dart';
import 'package:flyereats/model/promo.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/shop_category.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/location.dart';

class ExampleModel {
  static List<Promo> getPromos() {
    List<Promo> _promos = [];
/*    _promos.add(Promo(
      "Promo Title",
      "https://lh3.googleusercontent.com/proxy/tC_9v1lUe2qoF2tdzqVDVX9XrCM1JW0JEqudJkR0UWbkaUHZ-2-ARg3E3NVQeX44QYu9Glci0vlE3l0xO-G_AesczDZf1NShZ17zJwRfuEMuGYO0L1LH4vWN1Cglk7F9m9oeCLiqbw-v",
      "On selected beverages",
    ));*/
    _promos.add(Promo(
      "Promo Title",
      "https://www.bca.co.id/~/media/Images/Default/201904/20190424-sakukupromo-banner",
      "On order above ",
    ));
    _promos.add(Promo(
      "Promo Title",
      "https://www.bca.co.id/-/media/Images/credit-card/2017/04/20170428-promo-seru-sakuku.ashx",
      "On selected beverages",
    ));

    return _promos;
  }

  static List<Restaurant> getRestaurants() {
    List<Restaurant> _topRestaurants = [];
    _topRestaurants.add(Restaurant(
        "1",
        "Amuthasurabhi Amuthasurabhi dasdasdasd",
        "25 mins",
        "4.5",
        "https://media-cdn.tripadvisor.com/media/photo-s/12/c1/c3/f5/restaurant-araz.jpg",
        "South Indian | North Indian",
        "Pollachi",
        discountTitle: "30% OFF",
        discountDescription: "30 % Off Up to 60 RS"));
    _topRestaurants.add(Restaurant(
      "2",
      "Gowri Khrisna",
      "32 mins",
      "4.7",
      "https://cdn.vox-cdn.com/thumbor/r6GaFXzgvkbJsq5ioEyxXtqQYlM=/0x0:2000x1335/1200x800/filters:focal(840x508:1160x828)/cdn.vox-cdn.com/uploads/chorus_image/image/66533246/2019_10_07_Pilot_restaurant_003.0.jpg",
      "South Indian | North Indian",
      "Pollachi",
    ));
    _topRestaurants.add(Restaurant(
      "3",
      "Ruchi Resta",
      "33 mins",
      "4.1",
      "https://media-cdn.tripadvisor.com/media/photo-s/13/c0/61/84/indian-summer-nights.jpg",
      "South Indian | North Indian",
      "Pollachi",
    ));
    _topRestaurants.add(Restaurant(
      "4",
      "Suryaa",
      "10 mins",
      "4.6",
      "https://media-cdn.tripadvisor.com/media/photo-s/10/14/58/e3/restaurant-roadside-view.jpg",
      "Pizza",
      "Pollachi",
    ));
    _topRestaurants.add(Restaurant(
        "5",
        "The Dinner",
        "20 mins",
        "4.3",
        "https://media-cdn.tripadvisor.com/media/photo-s/0f/95/ff/60/indian-cuisine.jpg",
        "Tandorine",
        ""));
    _topRestaurants.add(Restaurant(
      "6",
      "Other Restaurant",
      "45 mins",
      "4.2",
      "https://akm-img-a-in.tosshub.com/indiatoday/images/story/201509/dhaba-story_647_090415065808.jpg",
      "Italian Cuisine",
      "Pollachi",
    ));
    _topRestaurants.add(Restaurant(
      "8",
      "Other Restaurant",
      "15 mins",
      "4.9",
      "https://bali.queenstandoor.com/upload/gallery/large_Insade1.jpg",
      "South Indian | North Indian",
      "Pollachi",
    ));

    _topRestaurants.add(Restaurant(
      "9",
      "Other Restaurant",
      "15 mins",
      "4.9",
      "https://bali.queenstandoor.com/upload/gallery/large_Insade1.jpg",
      "South Indian | North Indian",
      "Pollachi",
    ));

    _topRestaurants.add(Restaurant(
      "10",
      "Other Restaurant",
      "15 mins",
      "4.9",
      "https://bali.queenstandoor.com/upload/gallery/large_Insade1.jpg",
      "South Indian | North Indian",
      "Pollachi",
    ));

    _topRestaurants.add(Restaurant(
      "11",
      "Other Restaurant",
      "15 mins",
      "4.9",
      "https://bali.queenstandoor.com/upload/gallery/large_Insade1.jpg",
      "South Indian | North Indian",
      "Pollachi",
    ));
    return _topRestaurants;
  }

  static List<ShopCategory> getShopCategories() {
    List<ShopCategory> _listShopCategory = [];
    _listShopCategory
        .add(ShopCategory("Restaurants", "assets/restaurants.svg"));
    _listShopCategory.add(ShopCategory("Grocery", "assets/groceries.svg"));
    _listShopCategory.add(ShopCategory("Veg & Fruits", "assets/vegfruits.svg"));
    _listShopCategory.add(ShopCategory("Meat", "assets/meat.svg"));

    return _listShopCategory;
  }

  static List<FoodCategory> getFoodCategories() {
    List<FoodCategory> _listFoodCategory = [];
    _listFoodCategory.add(FoodCategory("Pizza",
        "https://www.biggerbolderbaking.com/wp-content/uploads/2019/07/15-Minute-Pizza-WS-Thumbnail.png"));
    _listFoodCategory.add(FoodCategory("North Indian",
        "https://restaurantindia.s3.ap-south-1.amazonaws.com/s3fs-public/content6079.jpg"));
    _listFoodCategory.add(FoodCategory("South Indian",
        "https://i.pinimg.com/originals/9b/58/33/9b58338873b60ec0d32cf74cf9ff8cc0.jpg"));
    _listFoodCategory.add(FoodCategory("Thandoories",
        "https://tasteasianfood.com/wp-content/uploads/2019/11/Tandoori-chicken-featured-image.jpeg"));
    _listFoodCategory.add(FoodCategory("Chinese",
        "https://asset.kompas.com/crops/pvHZPuSw1hJ6b290QZjCMEQXQG4=/0x5:1750x1171/750x500/data/photo/2017/02/28/3675196636.jpg"));
    _listFoodCategory.add(FoodCategory("Japanese",
        "https://jpninfo.com/wp-content/uploads/2018/03/sushi-platter.jpg"));
    _listFoodCategory.add(FoodCategory("Italian Cuisine",
        "https://www.discoverparramatta.com/sites/discoverparra/files/styles/style_803x454/public/header-images/1362522%20Italian%20pasta%20.jpg?itok=3vq9422F"));
    _listFoodCategory.add(FoodCategory("Snack",
        "https://www.sensoryvalue.com/wp-content/uploads/2018/04/24_04-768x512.png"));
    return _listFoodCategory;
  }

  static List<BannerItem> getBanners() {
    List<BannerItem> _listBanner = [];
    _listBanner.add(BannerItem(
        "https://d3awvtnmmsvyot.cloudfront.net/api/file/UGQPOPoiRxu66Pb6KpjV/convert?fit=max&w=1450&quality=60&cache=true&rotate=exif&compress=true",
        ""));
    _listBanner.add(BannerItem(
        "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/slideshows/powerhouse_vegetables_slideshow/650x350_powerhouse_vegetables_slideshow.jpg",
        ""));
    _listBanner.add(BannerItem(
        "https://d3awvtnmmsvyot.cloudfront.net/api/file/UGQPOPoiRxu66Pb6KpjV/convert?fit=max&w=1450&quality=60&cache=true&rotate=exif&compress=true",
        ""));
    _listBanner.add(BannerItem(
        "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/slideshows/powerhouse_vegetables_slideshow/650x350_powerhouse_vegetables_slideshow.jpg",
        ""));
    return _listBanner;
  }

  static List<Food> getFoods() {
    List<Food> _listFoods = [];
    _listFoods.add(Food(
      "1",
        "Idly",
        "Loremp ipsum dos amet color Loremp ipsum dos amet color Loremp ipsum dos amet color",
        310.32,
        "https://www.kannammacooks.com/wp-content/uploads/soft-idli-batter-recipe-using-idli-rava-mixie-blender-method.jpg",
        true));
    _listFoods.add(Food(
        "2",
        "Masala Dosa",
        "Loremp ",
        3152,
        "https://cdn.theculturetrip.com/wp-content/uploads/2017/08/13040792475_51fdc1f447_k.jpg",
        false));
    _listFoods.add(Food(
      "3",
        "Rogan Josh",
        "Loremp ipsum dos amet color",
        10,
        "https://img.theculturetrip.com/1024x/smart/wp-content/uploads/2017/08/1024px-rogan_josh.jpg",
        false));
    _listFoods.add(Food(
        "4",
        "Hyderabadi Biriyani",
        "Loremp ipsum dos amet color",
        70,
        "https://www.kannammacooks.com/wp-content/uploads/soft-idli-batter-recipe-using-idli-rava-mixie-blender-method.jpg",
        true));
    _listFoods.add(Food(
        "5",
        "Indian chaats",
        "Loremp ipsum dos amet color",
        90,
        "https://img.theculturetrip.com/1024x/smart/wp-content/uploads/2017/08/6456856581_b68cf171fd_b.jpg",
        true));
    _listFoods.add(Food(
        "6",
        "Vada Pav",
        "Loremp ipsum dos amet color",
        10,
        "https://img.theculturetrip.com/1024x/smart/wp-content/uploads/2017/08/3437240332_48cea3c8ca_o.jpg",
        true));

    return _listFoods;
  }

  static FoodCart getFoodCart() {
    FoodCart cart = FoodCart(Map<int, FoodCartItem>());
    cart.cart[5] = FoodCartItem(5, ExampleModel.getFoods()[0], 2);
    cart.cart[4] = FoodCartItem(4, ExampleModel.getFoods()[1], 2);
    cart.cart[1] = FoodCartItem(1, ExampleModel.getFoods()[5], 3);
    return cart;
  }

  static List<Address> getAddresses() {
    List<Address> list = [];

    list.add(Address(
        1, "Maumere", "It is somewhere in Indonesia", AddressType.other,
        latitude: "", longitude: ""));

    list.add(Address(
        2,
        "Home",
        "No 217, C Block, Vascon Venus, Hosaroad Junction, Elec.city, Bangalore 560100",
        AddressType.other,
        latitude: "",
        longitude: ""));

    list.add(Address(
        3,
        "Others",
        "No 217, C Block, Vascon Venus, Hosaroad Junction, Elec.city, Bangalore 560100",
        AddressType.other,
        latitude: "",
        longitude: ""));

    list.add(Address(
        4,
        "Office",
        "No 217, C Block, Vascon Venus, Hosaroad Junction, Elec.city, Bangalore 560100",
        AddressType.other,
        latitude: "",
        longitude: ""));

    return list;
  }

  static List<Location> getLocations() {
    List<Location> list = List();
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));
    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    list.add(Location(
      id: "1",
      location: "Tamilnadu/Adiramapattinam",
      address: "Adiramappinam, Thanjvur, Tamilnadu",
    ));

    return list;
  }

  static List<Order> getOrderHistory() {
    List<Order> listOrder = List();

    listOrder.add(Order(ExampleModel.getRestaurants()[0],
        ExampleModel.getFoodCart(), "30 April 2020", "Delivered"));
    listOrder.add(Order(ExampleModel.getRestaurants()[1],
        ExampleModel.getFoodCart(), "20 May 2020", "Delivered"));
    listOrder.add(Order(ExampleModel.getRestaurants()[2],
        ExampleModel.getFoodCart(), "1 June 2020", "Delivered"));

    return listOrder;
  }

  static List<String> getLoyatyRewards() {
    List<String> list = List();

    list.add(
        "https://impact21.com/wp-content/uploads/Featured-Image-Graphic-795x500-Loyalty-Misconceptions2.jpg");
    list.add("https://miro.medium.com/max/1200/1*oKNynti0JWjuNqzHoI0Fgw.png");
    list.add(
        "https://revenue-hub.com/wp-content/uploads/2017/07/loyalty-rewards-1024x606.jpg");
    list.add(
        "https://www.ledgerinsights.com/wp-content/uploads/2019/10/rewards-customer-loyalty-810x476.jpg");
    list.add(
        "https://www.cpapsupplyusa.com/pub/media/images/loyalty-points.jpg");
    return list;
  }
}
