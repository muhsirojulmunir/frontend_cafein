import 'package:cafein/controllers/power_share/ask_controller.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AturanWidget extends StatelessWidget {
  const AturanWidget({super.key, required this.controller});
  final AskController controller;

  @override
  Widget build(BuildContext context) {
    final data = controller.aturan;
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: ColorApp.colorPrimary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                width: 5.w,
                child: Text(
                  '-',
                  style: TextStyleApp.bodyTextSmallBold.copyWith(
                    color: ColorApp.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data[0]['title'],
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    color: ColorApp.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                width: 5.w,
                child: Text(
                  '-',
                  style: TextStyleApp.bodyTextSmallBold.copyWith(
                    color: ColorApp.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data[1]['title'],
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    color: ColorApp.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                width: 5.w,
                child: Text(
                  '-',
                  style: TextStyleApp.bodyTextSmallBold.copyWith(
                    color: ColorApp.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data[2]['title'],
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    color: ColorApp.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                width: 5.w,
                child: Text(
                  '-',
                  style: TextStyleApp.bodyTextSmallBold.copyWith(
                    color: ColorApp.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data[3]['title'],
                  style: TextStyleApp.bodyTextSmall.copyWith(
                    color: ColorApp.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
