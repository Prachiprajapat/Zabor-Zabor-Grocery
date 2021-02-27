
import 'package:flutter/material.dart';

enum ReservationStatusEnum {
  approved,
  waiting,
  cancelled}



  Color reservationStatusEnumToColor(ReservationStatusEnum reservationStatusEnum) {
  switch (reservationStatusEnum) {
    case ReservationStatusEnum.approved:
      return Colors.greenAccent[700];
    case ReservationStatusEnum.waiting:
      return Colors.white;
      case ReservationStatusEnum.cancelled:
      return Colors.red;
      }
  }

  Color reservationStatusEnumToTextColor(ReservationStatusEnum reservationStatusEnum) {
  switch (reservationStatusEnum) {
    case ReservationStatusEnum.approved:
      return Colors.white;
    case ReservationStatusEnum.waiting:
      return Colors.black;
      case ReservationStatusEnum.cancelled:
      return Colors.white;
      }
  }

  double reservationStatusEnumToHorizontalPadding(ReservationStatusEnum reservationStatusEnum) {
  switch (reservationStatusEnum) {
    case ReservationStatusEnum.approved:
      return 16;
    case ReservationStatusEnum.waiting:
      return 22;
      case ReservationStatusEnum.cancelled:
      return 16;
      }
  }

  reservationStatusEnumToTitle(ReservationStatusEnum reservationStatusEnum) {
  switch (reservationStatusEnum) {
    case ReservationStatusEnum.approved:
      return "Approved";
    case ReservationStatusEnum.waiting:
      return "Waiting";
      case ReservationStatusEnum.cancelled:
      return "Cancelled";
      }
  }