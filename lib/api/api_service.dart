const String base = "http://127.0.0.1:8000/api";

class ApiService {
  static const String loginapi = "$base/login";
  static const String registerapi = "$base/register";
  static const String app = "$base/app";
  static const String probycategory = "$base/app/product/category/";
  static const String prodetail = "$base/app/product/prodetail/";
  static const String filterprodcut = "$base/app/product/filter/";
  static const String getAllProducts = "$base/app/product/getllProducts/";
  static const String getAllCategory = "$base/app/product/getallCategories/";
  static const String getAllOnboard = "$base/app/product/getallOnboard/";
}
