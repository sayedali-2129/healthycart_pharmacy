import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';

typedef FutureResult<T> = Future<Either<MainFailure, T>>;
