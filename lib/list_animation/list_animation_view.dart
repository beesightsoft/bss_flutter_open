import 'package:bss_flutter_open/list_animation/food.dart';
import 'package:bss_flutter_open/list_animation/list_animation_item.dart';
import 'package:flutter/material.dart';

class ListAnimationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListAnimationViewState();
  }
}

class _ListAnimationViewState extends State<ListAnimationView> {
  List<Food> _foods;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _foods = [
      Food(
        name: "Bánh phồng tôm Sa Giang",
        image:
            "http://www.vietfuntravel.com.vn/image/data/Blog/dac-san/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua-1.jpg",
        description:
            "Bánh được chế biến từ bột khoai mì tinh chế kết hợp với tôm xay nhuyễn, một ít hạt tiêu đập dập và một số gia vị: muối, đường, bột ngọt. Các thành phần nguyên liệu sau khi trộn với nhau sẽ được nhồi vào những chiếc túi vải hình ống và đưa vào nồi hấp. Sau khi hấp chín, những cây bột này sẽ được cắt thành từng lát tròn mỏng rồi đem phơi khô, đóng gói cẩn thận và cung cấp ra thị trường.",
        price: "23.000 VNĐ",
      ),
      Food(
        name: "Nem Lai Vung",
        image:
            "http://www.vietfuntravel.com.vn/image/data/Blog/dac-san/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua-2.jpg",
        description:
            "Nem Lai Vung có hương vị thơm ngon, độc đáo. Nguyên liệu để làm nem gồm có thịt heo nạc xay nhuyễn, da heo (bì) xắt nhỏ trộn với thính (gạo rang), tỏi thái mỏng, hạt tiêu để nguyên hạt... Tùy theo bí quyết riêng của từng người mà có cách làm nem khác nhau.",
        price: "52.000 VNĐ",
      ),
      Food(
        name: "Hủ tiếu Sa Đéc",
        image:
            "https://anh.24h.com.vn/upload/1-2013/images/2013-03-13/1363163776-an-hu-tieu-kho-o-Sa-Dec.jpg",
        description:
            "Hủ tiếu là món ăn quen thuộc của người dân Nam Bộ. Dù có nhiều nơi làm món này nhưng hủ tiếu Sa Đéc vẫn mang hương vị riêng. Hủ tiếu Sa Đéc độc đáo ở nguyên liệu làm bánh và nước dùng. Sợi bánh được làm từ bột gạo Sa Đéc, loại bột nổi tiếng hơn 100 năm nay và được xuất khẩu ra nhiều nước trên thế giới. Nước dùng với hủ tiếu được nấu bằng xương heo (xương ống) và một số gia vị “bí truyền”, tạo ra hương vị thơm, ngọt đậm đà.",
        price: "20.000 VNĐ",
      ),
      Food(
        name: "Cá lóc nướng trui cuốn lá sen non",
        image:
            "http://www.vietfuntravel.com.vn/image/data/Blog/dac-san/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua-10.jpg",
        description:
            "Cá lóc nướng trui là đặc sản nổi tiếng ở miền Tây. Tuy nhiên, cá lóc nướng cuốn lá sen non có lẽ chỉ ở vùng Đồng Tháp Mười mới phổ biến. Cá lóc tươi mang về sẽ được rửa sạch, sơ chế, bỏ mật cá để cả vảy rồi lấy muối hạt rửa lại, để ráo nước. Người chế biến thường dùng một cây sả tươi luồn thẳng từ miệng cá xuống dưới thân rồi đem nướng. Cách làm này vừa khử tanh vừa mang lại hương vị thơm ngon cho cá.",
        price: "150.000 VNĐ",
      ),
      Food(
        name: "Cá linh Đồng Tháp",
        image:
            "http://www.vietfuntravel.com.vn/image/data/Blog/dac-san/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua-13.jpg",
        description:
            "Cá linh có thể chế biến thành nhiều món nhưng ngon nhất vẫn là nấu lẩu với bông điên điển. Cá linh để nguyên con, móc ruột, rửa sạch, để ráo rồi sắp ra đĩa. Đợi nồi lẩu sôi sùng sục, nêm nếm gia vị cho vừa ăn thì cho cá linh, bông điên điển, bông súng, rau thơm vào. Lẩu bông điên điển cá linh non ăn nóng cùng với bún hoặc cơm nóng đều được.",
        price: "80.000 VNĐ",
      ),
      Food(
        name: "Quýt hồng Lai Vung",
        image:
            "http://www.vietfuntravel.com.vn/image/data/Blog/dac-san/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua/top-cac-mon-dac-san-dong-thap-muoi-khong-nen-bo-qua-14.jpg",
        description:
            "Vùng đất Lai Vung (Đồng Tháp) được phù sa bồi đắp quanh năm nên đất đai màu mỡ, cây cối phát triển tươi tốt. Nhờ điều kiện thuận lợi này nên giống quýt hồng ở đây phát triển vượt trội, mang lại hiệu quả kinh tế cao. Quýt hồng Lai Vung nổi bật với hương vị thơm, ngọt, vỏ mỏng và ít hạt.",
        price: "15.000 VNĐ",
      ),
      Food(
        name: "Ốc treo giàn bếp",
        image:
            "https://cachnauan.net/wp-content/uploads/2015/10/mon-an-dac-san-dong-thap-1.jpg",
        description:
            "Con ốc để làm món ốc treo gác bếp là ốc lác. Ốc bắt được đem về rửa sạch, đựng trong giỏ đan bằng tre rồi đem treo chỗ cao trên giàn bếp. Ốc lác treo giàn bếp để lâu 4-5 tháng vẫn sống. Ốc treo giàn bếp béo mập, để hàng ngày khi nấu cơm khói xông vào giỏ đựng ốc, ốc sẽ ngửi khói xông lên là đạt yêu cầu.",
        price: "30.000 VNĐ",
      ),
    ];

    for (int i = 0; i < 20; i++)
      _foods.add(Food(
        name: _foods[i].name,
        image: _foods[i].image,
        description: _foods[i].description,
        price: _foods[i].price,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _foods.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: ListAnimationItem(
            food: _foods[index],
            onTap: () {
              setState(() =>
                  this._foods[index].isCheck = !this._foods[index].isCheck);
            },
          ));
        },
      ),
    );
  }
}
