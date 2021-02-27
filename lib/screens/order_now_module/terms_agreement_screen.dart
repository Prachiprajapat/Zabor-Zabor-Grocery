import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:zabor/app_localizations/app_localizations.dart';
import 'package:zabor/constants/constants.dart';
import 'package:zabor/screens/basket_screen_module/taxes_response_model.dart';
import 'package:zabor/screens/food_list_module/cart_model.dart';
import 'package:zabor/screens/order_now_module/order_now_screen.dart';

class TermsAgreementScreen extends StatefulWidget {
  final bool isWithoutLogin;
  const TermsAgreementScreen({Key key, this.isWithoutLogin = false}) : super(key: key);
  @override
  _TermsAgreementScreenState createState() => _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends State<TermsAgreementScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  List<String> listAgreement = new List<String>();
  @override
  void initState() {
    super.initState();

    listAgreement.add('Al aceptar autorizas a Mi Gente Online a enviar actualizaciones de tu orden por notifica-ciones  push y/o mensajes de texto. Puedes cambiar esto en tus preferencias.');
    listAgreement.add('Ordenes que contengan alcohol requieren identificación de la persona que recoge al momento de entrega.');
    listAgreement.add('Para cualquier inconveniente puede escribir a migenteonline@mgkpr.com');
    listAgreement.add('Se poveerá un recibo de compra impreso.');
    listAgreement.add('En caso de “delivery” podrás dar propina al mensajero al momento de entregar la com-pra.');
    listAgreement.add('El precio especial publicado en shopper de especiales de Supermercado Mi Gente,  no aplica a los productos disponibles a través de la aplicación móvil y/o página web.');
    listAgreement.add('Los productos que requieran peso, por ejemplo carnes, vegetales, frutas,  estos podrán variar según sea el caso. Se comunicarán con el usuario si al momento de editar la or-den hay cambios.');
    listAgreement.add('Los tiempos de entrega son estimados y están sujetos a cambios en condiciones de tráfico y/o  tiempo.');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: buildAppBar(),
        body: Container(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: size.height * 0.8,

                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, position) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 1.0),
                              width: double.infinity,
                              child: Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (position + 1).toString() + '. ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: AppColors().kBlackColor),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              width: size.width * 0.85,
                                              child: Text(
                                              // 'text2',
                                              listAgreement[position],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: AppColors().kBlackColor),
                                              )
                                            ),
                                          ],
                                        )

                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                      indent: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: listAgreement.length,
                        ),
                        // child: Container(
                        //   child: Text(
                        //     strAgreement,
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.w500,
                        //         fontSize: 16,
                        //         color: AppColors().kBlackColor),
                        //
                        //     // readOnly: true,
                        //     // maxLines: 99,
                        //     // decoration: InputDecoration(
                        //     //   hintText: '',
                        //     //   border: OutlineInputBorder(),
                        //     // ),
                        //   ),
                        // )
                      ),
                      Container(
                          width: double.infinity,
                          height: size.height * 0.05,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton (
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.pop(context, {'isAggree': false});
                                  },
                                  child: Text(AppLocalizations.of(context).translate('Disagree'),
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                FlatButton (
                                  color: Colors.green,
                                  onPressed: () {
                                    Navigator.pop(context, {'isAggree': true});
                                  },
                                  child: Text(AppLocalizations.of(context).translate('Agree'),
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                )
                              ]
                          )
                      )
                    ]
                )
            )
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).translate('Terms and Agreement'),
      ),
      backgroundColor: AppColors().kWhiteColor,
      iconTheme: IconThemeData(color: AppColors().kBlackColor),
      textTheme: TextTheme(
          title: TextStyle(
              color: AppColors().kBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w600)),
    );
  }

}
