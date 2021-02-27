//final String baseUrl = "https://nodevg81.elb.cisinlive.com/";
//final String baseUrl = "https://zaboreats.com/backend/";
//final String baseUrl = "https://shop.zaboreats.com/backend/";
// final String baseUrl = "https://migente.online/backend/";
final String baseUrl = "https://migente.online/backend/";

//final String baseUrl = "https://rafelvg.elb.cisinlive.com/";
//final String baseUrl = "http://ec2-3-136-11-97.us-east-2.compute.amazonaws.com/backend/";
final String apiVersion = "api/";

enum Apis {
  registration,
  login,
  forgotPassword,
  home,
  restaurantDetail,
  categories,
  subCatgories,
  searchCategories,
  searchRestbyCat,
  filterRestaurants,
  popularRestaurants,
  newRestaurants,
  rateRestaurants,
  updateProfile,
  checkIn,
  staticPage,
  userCheckIns,
  feeds,
  appusers,
  sendFriendRequest,
  friendRequestList,
  friendRequestAction,
  myFriends,
  shareFeedback,
  like,
  unlike,
  friendDetail,
  restaurantGallery,
  suggestCategory,
  changePassword,
  notificationList,
  menu,
  favorite,
  addToCart,
  myBasket,
  addAddress,
  getAddress,
  deleteAddress,
  placeOrder,
  clearCart,
  orderHistory,
  socialLogin,
  makeReservation,
  myReservations,
  getSlots,
  searchRestByQuery,
  getTaxes,
  getAdverts,
  getTimeLine,
  getOrderDetails,
  getDiscountWithLocation,
  getDiscountWithUser,
  cancelOrder,
}

apisToUrls(Apis endpoint) {
  switch (endpoint) {
    case Apis.registration:
      return baseUrl + apiVersion + "registration";
    case Apis.login:
      return baseUrl + apiVersion + "login";
    case Apis.forgotPassword:
      return baseUrl + apiVersion + "forgetPassword";
    case Apis.home:
      return baseUrl + apiVersion + "homepageRestaurant";
    case Apis.restaurantDetail:
      return baseUrl + apiVersion + "restaurant-detail";
    case Apis.categories:
      return baseUrl + apiVersion + "get-categories";
    case Apis.subCatgories:
      return baseUrl + apiVersion + "get-subcategories?cat_id=";
    case Apis.searchCategories:
      return baseUrl + apiVersion + "category-search";
    case Apis.searchRestbyCat:
      return baseUrl + apiVersion + "getrestaurantbysubcat";
    case Apis.filterRestaurants:
      return baseUrl + apiVersion + "filter-restaurant";
    case Apis.popularRestaurants:
      return baseUrl + apiVersion + "allpopular-restaurant";
    case Apis.newRestaurants:
      return baseUrl + apiVersion + "allnewest-restaurant";
    case Apis.rateRestaurants:
      return baseUrl + apiVersion + "rateRestaurant";
    case Apis.updateProfile:
      return baseUrl + apiVersion + "user/update";
    case Apis.checkIn:
      return baseUrl + apiVersion + "checkin";
    case Apis.staticPage:
      return baseUrl + apiVersion + "getstaticPages?pageid=";
    case Apis.userCheckIns:
      return baseUrl + apiVersion + "usercheckins";
    case Apis.feeds:
      return baseUrl + apiVersion + "feed";
    case Apis.appusers:
      return baseUrl + apiVersion + "getappusers";
    case Apis.sendFriendRequest:
      return baseUrl + apiVersion + "send-friendrequest";
    case Apis.friendRequestList:
      return baseUrl + apiVersion + "friend-requests";
    case Apis.friendRequestAction:
      return baseUrl + apiVersion + "friend-request-action";
    case Apis.myFriends:
      return baseUrl + apiVersion + "myfriend-list";
    case Apis.shareFeedback:
      return baseUrl + apiVersion + "share-feedback";
    case Apis.like:
      return baseUrl + apiVersion + "checkin-like";
    case Apis.unlike:
      return baseUrl + apiVersion + "checkin-unlike";
    case Apis.friendDetail:
      return baseUrl + apiVersion + "friend-detail";
    case Apis.restaurantGallery:
      return baseUrl + apiVersion + "restaurant/gallery";
    case Apis.suggestCategory:
      return baseUrl + apiVersion + "suggest-category";
    case Apis.changePassword:
      return baseUrl + apiVersion + "change-password";
    case Apis.notificationList:
      return baseUrl + apiVersion + "restaurant/getnotificationsforapp";
    case Apis.menu:
      return baseUrl + apiVersion + "restaurant/menu";
    case Apis.favorite:
      return baseUrl + apiVersion + "updateFavorite";
    case Apis.addToCart:
      return baseUrl + apiVersion + "addtocart";
    case Apis.myBasket:
      return baseUrl + apiVersion + "getcart";
    case Apis.addAddress:
      return baseUrl + apiVersion + "add-address";
    case Apis.getAddress:
      return baseUrl + apiVersion + "get-address";
    case Apis.deleteAddress:
      return baseUrl + apiVersion + "delete-address";
    case Apis.placeOrder:
        return baseUrl + apiVersion + "placeorder";
    case Apis.clearCart:
      return baseUrl + apiVersion + "clearCart";
    case Apis.orderHistory:
      return baseUrl + apiVersion + "get-orders";
    case Apis.socialLogin:
      return baseUrl + apiVersion + "loginbySocial";
    case Apis.makeReservation:
      return baseUrl + apiVersion + "make-reservation";
    case Apis.myReservations:
      return baseUrl + apiVersion + "getuser-reservation";
    case Apis.getSlots:
      return baseUrl + apiVersion + "getTimeslots";
    case Apis.searchRestByQuery:
      return baseUrl + apiVersion + "restaurant/search";
    case Apis.getTaxes:
      return baseUrl + apiVersion + "getTaxs";
    case Apis.getAdverts:
      return baseUrl + apiVersion + "getadverts";
    case Apis.getTimeLine:
      return baseUrl + apiVersion + "getOrderStages";
    case Apis.getOrderDetails:
      return baseUrl + apiVersion + "getOrderDetail";
    case Apis.getDiscountWithLocation:
      return baseUrl + apiVersion + "getDiscountsWithinLocation";
    case Apis.getDiscountWithUser:
      return baseUrl + apiVersion + "getDiscounts";
    case Apis.cancelOrder:
      return baseUrl + apiVersion + "cancelOrder";
  }
}

class AppVersion {
  static dynamic iOS = "3.4";
  static dynamic android = "1.0.26";
}
