import 'package:edagang/scoped/ads_scoped.dart';
import 'package:edagang/scoped/biz_scoped.dart';
import 'package:edagang/scoped/scoped_cart.dart';
import 'package:edagang/scoped/scoped_order.dart';
import 'package:edagang/scoped/scoped_user.dart';
import 'package:edagang/scoped/shop_home_scoped.dart';
import 'package:edagang/scoped/upskill_scoped.dart';
import 'package:scoped_model/scoped_model.dart';


class MainScopedModel extends Model with BizAppScopedModel, UpskillScopedModel, AdvertAppScopedModel, ShopHomeScopedModel, CartScopedModel, UserScopedModel, OrderScopedModel {
}
