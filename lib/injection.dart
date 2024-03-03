import 'package:flutter_preload_videos/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';


// final GetIt getIt = GetIt.instance;

// @injectableInit
// void configureInjection(String env) {
//   $initGetIt(getIt, environment: env);
// }


final getIt = GetIt.instance;  
  
@InjectableInit(  
  initializerName: 'init', // default  
  preferRelativeImports: true, // default  
  asExtension: true, // default  
)  
void configureInjection(String prod) => getIt.init(environment: prod);