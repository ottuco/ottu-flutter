enum PGCode {
  mpgs(code: "mpgs-testing", name: "MPGS"),
  knet(code: "knet-staging", name: "Knet"),
  benefit(code: "benefit", name: "Benefit"),
  benefitpay(code: "benefitpay", name: "Benefit Pay"),
  stc_pay(code: "stc_pay", name: "Stc Pay"),
  nbk_mpgs(code: "nbk-mpgs", name: "Nbk Mpgs"),
  urpay(code: "urpay", name: "Ur Pay"),
 // tamara(code: "tamara", name: "Tamara"),
 // tabby(code: "tabby", name: "Tabby"),
  tap_pg(code: "tap_pg", name: "Tag PG", inverselyRelated: "ottu_sdk"),
  ottu_sdk(code: "ottu_sdk", name: "Ottu Sdk", inverselyRelated: "tap_pg");

  const PGCode({required this.code, required this.name, this.inverselyRelated});

  final String name;
  final String code;
  final String? inverselyRelated;
}
