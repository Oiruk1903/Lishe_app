import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/bmi_model.dart';
import '../models/weight_entry_model.dart';

abstract class WeightRemoteDataSource {
  Future<WeightEntryModel> logWeight(Map<String, dynamic> data);
  Future<List<WeightEntryModel>> getHistory({int days = 30});
  Future<WeightEntryModel> getLatest();
  Future<BmiModel> getBmi();
  Future<Map<String, dynamic>> getTrends({int days = 30});
  Future<void> deleteEntry(String id);
}

class WeightRemoteDataSourceImpl implements WeightRemoteDataSource {
  final Dio dio;

  WeightRemoteDataSourceImpl(this.dio);

  @override
  Future<WeightEntryModel> logWeight(Map<String, dynamic> data) async {
    final response = await dio.post(ApiEndpoints.weights, data: data);
    return WeightEntryModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<WeightEntryModel>> getHistory({int days = 30}) async {
    final response = await dio.get(
      ApiEndpoints.weights,
      queryParameters: {'days': days},
    );
    final List<dynamic> items = response.data['data'] as List<dynamic>;
    return items
        .map((json) =>
            WeightEntryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<WeightEntryModel> getLatest() async {
    final response = await dio.get(ApiEndpoints.weightsLatest);
    return WeightEntryModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<BmiModel> getBmi() async {
    final response = await dio.get(ApiEndpoints.weightsBmi);
    return BmiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<Map<String, dynamic>> getTrends({int days = 30}) async {
    final response = await dio.get(
      ApiEndpoints.weightsTrends,
      queryParameters: {'days': days},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<void> deleteEntry(String id) async {
    await dio.delete('${ApiEndpoints.weights}/$id');
  }
}
