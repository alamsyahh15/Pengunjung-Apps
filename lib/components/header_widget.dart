import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final bool isSearchEnable;
  final Function(String value) onSubmited;
  final Function() onClear;

  const HeaderWidget(
      {Key key,
      this.isSearchEnable = true,
      @required this.onSubmited,
      @required this.onClear})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.isSearchEnable
            ? SearchbarWidget(
                onClear: () {
                  onClear();
                },
                onSubmit: (String value) {
                  onSubmited(value);
                },
              )
            : SizedBox(),
      ],
    );
  }
}

class SearchbarWidget extends StatelessWidget {
  final double paddingSize;
  final Function() onClear;
  final Function(String value) onSubmit;
  SearchbarWidget(
      {Key key,
      this.paddingSize = 8.0,
      @required this.onClear,
      @required this.onSubmit})
      : super(key: key);

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(this.paddingSize),
      child: Row(
        children: [
          CustomButton(
            icon: Icons.chevron_left,
            iconColor: Colors.grey,
            size: 40.0,
            borderRadius: 50.0,
            onTap: () => Navigator.pop(context),
            elevation: 5.0,
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: this.paddingSize),
              child: CupertinoSearchTextField(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                placeholder: 'Cari data kunjungan saya!',
                prefixInsets: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10.0,
                ),
                onChanged: (value) {
                  onSubmit(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String imgPath;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Color color;
  final double elevation;
  final double size;
  final double borderRadius;
  final void Function() onTap;

  const CustomButton(
      {Key key,
      this.imgPath = '',
      this.icon,
      this.color = Colors.white,
      this.iconSize = 0,
      this.iconColor = Colors.black,
      this.elevation = 0.0,
      this.size = 30.0,
      this.borderRadius = 7.5,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: this.color,
      borderRadius: BorderRadius.circular(this.borderRadius),
      elevation: this.elevation,
      child: InkWell(
        borderRadius: BorderRadius.circular(this.borderRadius),
        child: Container(
          height: this.size,
          width: this.size,
          alignment: Alignment.center,
          child: this.imgPath != ''
              ? Image.asset(
                  this.imgPath,
                  color: this.iconColor,
                  width: this.iconSize > 0 ? this.iconSize : this.size * 0.75,
                )
              : Icon(
                  this.icon,
                  size: this.iconSize > 0 ? this.iconSize : this.size * 0.75,
                  color: this.iconColor,
                ),
        ),
        onTap: this.onTap,
      ),
    );
  }
}
