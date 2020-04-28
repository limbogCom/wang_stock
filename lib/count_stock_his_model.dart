class CountStockHis{
  final String countStockHisId;
  final String countStockHisCode;
  final String countStockHisProdCode;
  final String countStockHisNumCount;
  final String countStockHisProdUnit;
  final String countStockHisEmpCount;
  final String countStockHisDateCount;
  final String countStockHisComment;

  CountStockHis({
    this.countStockHisId,
    this.countStockHisCode,
    this.countStockHisProdCode,
    this.countStockHisNumCount,
    this.countStockHisProdUnit,
    this.countStockHisEmpCount,
    this.countStockHisDateCount,
    this.countStockHisComment
  });

  factory CountStockHis.fromJson(Map<String, dynamic> json){
    return new CountStockHis(
      countStockHisId: json['cth_id'],
      countStockHisCode: json['ct_code'],
      countStockHisProdCode: json['ctl_pcode'],
      countStockHisNumCount: json['cth_num'],
      countStockHisProdUnit: json['cth_unit'],
      countStockHisEmpCount: json['cth_emp'],
      countStockHisDateCount: json['cth_date'],
      countStockHisComment: json['cth_comments'],
    );
  }
}