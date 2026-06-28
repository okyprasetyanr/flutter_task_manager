import 'package:task_manager/feature/login/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelCompany {
  final String companyId;
  final String companyName;
  final DateTime companyJoin;

  ModelCompany({
    required this.companyId,
    required this.companyName,
    required this.companyJoin,
  });

  factory ModelCompany.fromJson(Map<String, dynamic> data) {
    return ModelCompany(
      companyId: data[EnumCompany.companyId.value],
      companyName: data[EnumCompany.companyName.value],
      companyJoin: HelperDateConvert.toDateTime(
        data[EnumCompany.companyJoin.value],
      ),
    );
  }
}
