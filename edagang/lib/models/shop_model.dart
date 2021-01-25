
class Banner_ {
  final String imageUrl;
  final String title;
  final String type;
  final String itemId;
  final String remark;

  Banner_({this.imageUrl, this.title, this.type, this.itemId, this.remark});

  factory Banner_.fromJson(Map<String, dynamic> parsedJson){
    return Banner_(
        imageUrl:parsedJson['image_url'],
        title:parsedJson['title'],
        type:parsedJson['type'],
        itemId:parsedJson['item_id'],
        remark:parsedJson['remark']
    );
  }

}


class Images {
  int id;
  String productId;
  String imageURL;

  Images({
    this.id,
    this.productId,
    this.imageURL,
  });
}

class Video {
  int id;
  String productId;
  String videoURL;

  Video({
    this.id,
    this.productId,
    this.videoURL,
  });
}

class Category {
  final int parentId;
  final int catid;
  final String catname;
  final String catimage;

  Category({this.parentId, this.catid, this.catname, this.catimage});

}

class Product {
  int id;
  int prd_id;
  String cart_id;
  String grp_id;
  String sku;
  String category_id;
  String category_name;
  String merchant_id;
  String merchant_name;
  String name;
  String summary;
  String details;
  String price;
  String delivery;
  String ispromo;
  String promoPrice;
  String promoStartdate;
  String promoEnddate;
  String image;
  List<Images> images;
  List<Video> videos;
  List<Review> reviews;
  List<ProductVariation> variations;
  String hasVariants;
  String stock;
  int minOrder;
  List<Product> variants;
  List<ProductVariation> optionValues;
  List<VariationOption> optionTypes;
  bool fav;
  double rating;
  int qty;
  int subTot;

  Product(
      {this.id,
        this.prd_id,
        this.cart_id,
        this.grp_id,
        this.sku,
        this.category_id,
        this.category_name,
        this.merchant_id,
        this.merchant_name,
        this.name,
        this.summary,
        this.details,
        this.price,
        this.delivery,
        this.ispromo,
        this.promoPrice,
        this.promoStartdate,
        this.promoEnddate,
        this.hasVariants,
        this.variations,
        this.stock,
        this.minOrder,
        this.image,
        this.images,
        this.videos,
        this.variants,
        this.optionTypes,
        this.optionValues,
        this.reviews,
        this.fav,
        this.rating,
        this.qty,
        this.subTot
      }
      );
}

class ProductVariation {
  final int id;
  final String product_id;
  final String variation_name;
  final String have_image;
  final List<VariationOption> variation_option;


  ProductVariation({this.id, this.product_id, this.variation_name, this.have_image, this.variation_option});
}

class VariationOption {
  final int id;
  final String variation_id;
  final String option_name;
  final String unit_price;
  final String stock;
  final String image_url;

  VariationOption({this.id, this.variation_id, this.option_name, this.unit_price, this.stock, this.image_url});
}

class Review {
  String user_id;
  String product_id;
  String review_text;
  String rating;
  int uId;
  String userName;

  Review({
    this.user_id,
    this.product_id,
    this.review_text,
    this.rating,
    this.uId,
    this.userName,
  });
}

class MyCart {
  int id;
  String merchant_id;
  String company_name;
  String state;
  String courier_charges;
  double subtotal;
  List<CartProduct> cart_products;
  double total_courier;
  double total_cost;

  MyCart(
      {this.id,
        this.merchant_id,
        this.company_name,
        this.state,
        this.courier_charges,
        this.subtotal,
        this.cart_products,
        this.total_courier,
        this.total_cost,
      }
      );
}

class CartProduct {
  int id;
  String cart_id;
  String merchant_id;
  String product_id;
  String quantity;
  String have_variation;
  String name;
  String price;
  String ispromo;
  String promo_price;
  String promo_startdate;
  String promo_enddate;
  String main_image;
  String stock;
  int min_order;
  List<CartVariation> cart_variation;

  CartProduct(
      {this.id,
        this.cart_id,
        this.merchant_id,
        this.product_id,
        this.quantity,
        this.have_variation,
        this.name,
        this.price,
        this.ispromo,
        this.promo_price,
        this.promo_startdate,
        this.promo_enddate,
        this.main_image,
        this.stock,
        this.min_order,
        this.cart_variation
      }
      );
}

class CartVariation {
  int id;
  String product_id;
  String variation_id;
  String option_id;
  String variation_name;
  String option_name;
  String unit_price;
  String stock;
  String image_url;

  CartVariation(
      {this.id,
        this.product_id,
        this.variation_id,
        this.option_id,
        this.variation_name,
        this.option_name,
        this.unit_price,
        this.stock,
        this.image_url
      }
      );

}

class Address {
  int id;
  bool isSelected;
  String name;
  String address;
  String postcode;
  String city_id;
  String state_id;
  String user_id;
  String mobile_no;
  String email;
  String default_shipping;
  String default_billing;
  String location_tag;
  String full_address;

  Address({this.id, this.isSelected, this.name, this.address, this.postcode, this.city_id, this.state_id, this.user_id, this.mobile_no, this.email, this.default_shipping, this.default_billing, this.location_tag, this.full_address, full_addres});
}

class OnlineBanking {
  int id;
  String bank_code;
  String bank_display_name;
  String bank_logo;
  bool isCheck;

  OnlineBanking({this.id, this.bank_code, this.bank_display_name, this.bank_logo, this.isCheck});
}

class OdrHistory {
  int id;
  String order_no;
  String total_price;
  String status;
  //String payment_status;
  String payment_err_code;
  String payment_err_desc;
  String payment_bank;
  String payment_txn_date;
  List<OrderGroup> order_group;

  OdrHistory(
      {this.id,
        this.order_no,
        this.total_price,
        this.status,
        //this.payment_status,
        this.payment_err_code,
        this.payment_err_desc,
        this.payment_bank,
        this.payment_txn_date,
        this.order_group});
}

class OrderGroup {
  int id;
  String order_id;
  String merchant_id;
  String courier_charges;
  String product_cost;
  int order_status_id;
  String order_status_name;
  String courier_id;
  String tracking_no;
  String merchant_name;
  String courier_company;
  List<OrderItem> order_items;

  OrderGroup(
      {this.id,
        this.order_id,
        this.merchant_id,
        this.courier_charges,
        this.product_cost,
        this.order_status_id,
        this.order_status_name,
        this.courier_id,
        this.tracking_no,
        this.merchant_name,
        this.courier_company,
        this.order_items});
}

class OrderItem {
  int id;
  String group_id;
  String product_id;
  String quantity;
  String price;
  String reviewed;
  String product_name;
  String main_image;

  OrderItem(
      {this.id,
        this.group_id,
        this.product_id,
        this.quantity,
        this.price,
        this.reviewed,
        this.product_name,
        this.main_image});
}


class KoopNgo {
  final int id;
  final String associateName;
  final String associateLogo;

  KoopNgo({this.id, this.associateName, this.associateLogo});

}