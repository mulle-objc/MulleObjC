#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif

// The point of this test is to get the method cache to grow. One of the
// threads will then operate for a small time on the old cache and the other
// on the fresh cache. If there were problems with that we would get a
// wrong method call and therefore also a wrong output sequence.
// Or maybe even a crash.
//
// So each thread should be going 0-1023 sequentially


#define FP   stdout


mulle_atomic_pointer_t     common_counter;

void   wait_for_other_thread( char *name)
{
   uintptr_t   value;

   fprintf( stderr, "%s wait\n", name);
   value = (uintptr_t) _mulle_atomic_pointer_read( &common_counter);
   while( (uintptr_t) _mulle_atomic_pointer_increment( &common_counter) == value)
      value++;
   fprintf( stderr, "%s start\n", name);
}


@interface Foo : NSObject
@end


@implementation Foo


+ (char *) foo_0 { return( "0"); }
+ (char *) foo_1 { return( "1"); }
+ (char *) foo_2 { return( "2"); }
+ (char *) foo_3 { return( "3"); }
+ (char *) foo_4 { return( "4"); }
+ (char *) foo_5 { return( "5"); }
+ (char *) foo_6 { return( "6"); }
+ (char *) foo_7 { return( "7"); }
+ (char *) foo_8 { return( "8"); }
+ (char *) foo_9 { return( "9"); }
+ (char *) foo_10 { return( "10"); }
+ (char *) foo_11 { return( "11"); }
+ (char *) foo_12 { return( "12"); }
+ (char *) foo_13 { return( "13"); }
+ (char *) foo_14 { return( "14"); }
+ (char *) foo_15 { return( "15"); }
+ (char *) foo_16 { return( "16"); }
+ (char *) foo_17 { return( "17"); }
+ (char *) foo_18 { return( "18"); }
+ (char *) foo_19 { return( "19"); }
+ (char *) foo_20 { return( "20"); }
+ (char *) foo_21 { return( "21"); }
+ (char *) foo_22 { return( "22"); }
+ (char *) foo_23 { return( "23"); }
+ (char *) foo_24 { return( "24"); }
+ (char *) foo_25 { return( "25"); }
+ (char *) foo_26 { return( "26"); }
+ (char *) foo_27 { return( "27"); }
+ (char *) foo_28 { return( "28"); }
+ (char *) foo_29 { return( "29"); }
+ (char *) foo_30 { return( "30"); }
+ (char *) foo_31 { return( "31"); }
+ (char *) foo_32 { return( "32"); }
+ (char *) foo_33 { return( "33"); }
+ (char *) foo_34 { return( "34"); }
+ (char *) foo_35 { return( "35"); }
+ (char *) foo_36 { return( "36"); }
+ (char *) foo_37 { return( "37"); }
+ (char *) foo_38 { return( "38"); }
+ (char *) foo_39 { return( "39"); }
+ (char *) foo_40 { return( "40"); }
+ (char *) foo_41 { return( "41"); }
+ (char *) foo_42 { return( "42"); }
+ (char *) foo_43 { return( "43"); }
+ (char *) foo_44 { return( "44"); }
+ (char *) foo_45 { return( "45"); }
+ (char *) foo_46 { return( "46"); }
+ (char *) foo_47 { return( "47"); }
+ (char *) foo_48 { return( "48"); }
+ (char *) foo_49 { return( "49"); }
+ (char *) foo_50 { return( "50"); }
+ (char *) foo_51 { return( "51"); }
+ (char *) foo_52 { return( "52"); }
+ (char *) foo_53 { return( "53"); }
+ (char *) foo_54 { return( "54"); }
+ (char *) foo_55 { return( "55"); }
+ (char *) foo_56 { return( "56"); }
+ (char *) foo_57 { return( "57"); }
+ (char *) foo_58 { return( "58"); }
+ (char *) foo_59 { return( "59"); }
+ (char *) foo_60 { return( "60"); }
+ (char *) foo_61 { return( "61"); }
+ (char *) foo_62 { return( "62"); }
+ (char *) foo_63 { return( "63"); }
+ (char *) foo_64 { return( "64"); }
+ (char *) foo_65 { return( "65"); }
+ (char *) foo_66 { return( "66"); }
+ (char *) foo_67 { return( "67"); }
+ (char *) foo_68 { return( "68"); }
+ (char *) foo_69 { return( "69"); }
+ (char *) foo_70 { return( "70"); }
+ (char *) foo_71 { return( "71"); }
+ (char *) foo_72 { return( "72"); }
+ (char *) foo_73 { return( "73"); }
+ (char *) foo_74 { return( "74"); }
+ (char *) foo_75 { return( "75"); }
+ (char *) foo_76 { return( "76"); }
+ (char *) foo_77 { return( "77"); }
+ (char *) foo_78 { return( "78"); }
+ (char *) foo_79 { return( "79"); }
+ (char *) foo_80 { return( "80"); }
+ (char *) foo_81 { return( "81"); }
+ (char *) foo_82 { return( "82"); }
+ (char *) foo_83 { return( "83"); }
+ (char *) foo_84 { return( "84"); }
+ (char *) foo_85 { return( "85"); }
+ (char *) foo_86 { return( "86"); }
+ (char *) foo_87 { return( "87"); }
+ (char *) foo_88 { return( "88"); }
+ (char *) foo_89 { return( "89"); }
+ (char *) foo_90 { return( "90"); }
+ (char *) foo_91 { return( "91"); }
+ (char *) foo_92 { return( "92"); }
+ (char *) foo_93 { return( "93"); }
+ (char *) foo_94 { return( "94"); }
+ (char *) foo_95 { return( "95"); }
+ (char *) foo_96 { return( "96"); }
+ (char *) foo_97 { return( "97"); }
+ (char *) foo_98 { return( "98"); }
+ (char *) foo_99 { return( "99"); }
+ (char *) foo_100 { return( "100"); }
+ (char *) foo_101 { return( "101"); }
+ (char *) foo_102 { return( "102"); }
+ (char *) foo_103 { return( "103"); }
+ (char *) foo_104 { return( "104"); }
+ (char *) foo_105 { return( "105"); }
+ (char *) foo_106 { return( "106"); }
+ (char *) foo_107 { return( "107"); }
+ (char *) foo_108 { return( "108"); }
+ (char *) foo_109 { return( "109"); }
+ (char *) foo_110 { return( "110"); }
+ (char *) foo_111 { return( "111"); }
+ (char *) foo_112 { return( "112"); }
+ (char *) foo_113 { return( "113"); }
+ (char *) foo_114 { return( "114"); }
+ (char *) foo_115 { return( "115"); }
+ (char *) foo_116 { return( "116"); }
+ (char *) foo_117 { return( "117"); }
+ (char *) foo_118 { return( "118"); }
+ (char *) foo_119 { return( "119"); }
+ (char *) foo_120 { return( "120"); }
+ (char *) foo_121 { return( "121"); }
+ (char *) foo_122 { return( "122"); }
+ (char *) foo_123 { return( "123"); }
+ (char *) foo_124 { return( "124"); }
+ (char *) foo_125 { return( "125"); }
+ (char *) foo_126 { return( "126"); }
+ (char *) foo_127 { return( "127"); }
+ (char *) foo_128 { return( "128"); }
+ (char *) foo_129 { return( "129"); }
+ (char *) foo_130 { return( "130"); }
+ (char *) foo_131 { return( "131"); }
+ (char *) foo_132 { return( "132"); }
+ (char *) foo_133 { return( "133"); }
+ (char *) foo_134 { return( "134"); }
+ (char *) foo_135 { return( "135"); }
+ (char *) foo_136 { return( "136"); }
+ (char *) foo_137 { return( "137"); }
+ (char *) foo_138 { return( "138"); }
+ (char *) foo_139 { return( "139"); }
+ (char *) foo_140 { return( "140"); }
+ (char *) foo_141 { return( "141"); }
+ (char *) foo_142 { return( "142"); }
+ (char *) foo_143 { return( "143"); }
+ (char *) foo_144 { return( "144"); }
+ (char *) foo_145 { return( "145"); }
+ (char *) foo_146 { return( "146"); }
+ (char *) foo_147 { return( "147"); }
+ (char *) foo_148 { return( "148"); }
+ (char *) foo_149 { return( "149"); }
+ (char *) foo_150 { return( "150"); }
+ (char *) foo_151 { return( "151"); }
+ (char *) foo_152 { return( "152"); }
+ (char *) foo_153 { return( "153"); }
+ (char *) foo_154 { return( "154"); }
+ (char *) foo_155 { return( "155"); }
+ (char *) foo_156 { return( "156"); }
+ (char *) foo_157 { return( "157"); }
+ (char *) foo_158 { return( "158"); }
+ (char *) foo_159 { return( "159"); }
+ (char *) foo_160 { return( "160"); }
+ (char *) foo_161 { return( "161"); }
+ (char *) foo_162 { return( "162"); }
+ (char *) foo_163 { return( "163"); }
+ (char *) foo_164 { return( "164"); }
+ (char *) foo_165 { return( "165"); }
+ (char *) foo_166 { return( "166"); }
+ (char *) foo_167 { return( "167"); }
+ (char *) foo_168 { return( "168"); }
+ (char *) foo_169 { return( "169"); }
+ (char *) foo_170 { return( "170"); }
+ (char *) foo_171 { return( "171"); }
+ (char *) foo_172 { return( "172"); }
+ (char *) foo_173 { return( "173"); }
+ (char *) foo_174 { return( "174"); }
+ (char *) foo_175 { return( "175"); }
+ (char *) foo_176 { return( "176"); }
+ (char *) foo_177 { return( "177"); }
+ (char *) foo_178 { return( "178"); }
+ (char *) foo_179 { return( "179"); }
+ (char *) foo_180 { return( "180"); }
+ (char *) foo_181 { return( "181"); }
+ (char *) foo_182 { return( "182"); }
+ (char *) foo_183 { return( "183"); }
+ (char *) foo_184 { return( "184"); }
+ (char *) foo_185 { return( "185"); }
+ (char *) foo_186 { return( "186"); }
+ (char *) foo_187 { return( "187"); }
+ (char *) foo_188 { return( "188"); }
+ (char *) foo_189 { return( "189"); }
+ (char *) foo_190 { return( "190"); }
+ (char *) foo_191 { return( "191"); }
+ (char *) foo_192 { return( "192"); }
+ (char *) foo_193 { return( "193"); }
+ (char *) foo_194 { return( "194"); }
+ (char *) foo_195 { return( "195"); }
+ (char *) foo_196 { return( "196"); }
+ (char *) foo_197 { return( "197"); }
+ (char *) foo_198 { return( "198"); }
+ (char *) foo_199 { return( "199"); }
+ (char *) foo_200 { return( "200"); }
+ (char *) foo_201 { return( "201"); }
+ (char *) foo_202 { return( "202"); }
+ (char *) foo_203 { return( "203"); }
+ (char *) foo_204 { return( "204"); }
+ (char *) foo_205 { return( "205"); }
+ (char *) foo_206 { return( "206"); }
+ (char *) foo_207 { return( "207"); }
+ (char *) foo_208 { return( "208"); }
+ (char *) foo_209 { return( "209"); }
+ (char *) foo_210 { return( "210"); }
+ (char *) foo_211 { return( "211"); }
+ (char *) foo_212 { return( "212"); }
+ (char *) foo_213 { return( "213"); }
+ (char *) foo_214 { return( "214"); }
+ (char *) foo_215 { return( "215"); }
+ (char *) foo_216 { return( "216"); }
+ (char *) foo_217 { return( "217"); }
+ (char *) foo_218 { return( "218"); }
+ (char *) foo_219 { return( "219"); }
+ (char *) foo_220 { return( "220"); }
+ (char *) foo_221 { return( "221"); }
+ (char *) foo_222 { return( "222"); }
+ (char *) foo_223 { return( "223"); }
+ (char *) foo_224 { return( "224"); }
+ (char *) foo_225 { return( "225"); }
+ (char *) foo_226 { return( "226"); }
+ (char *) foo_227 { return( "227"); }
+ (char *) foo_228 { return( "228"); }
+ (char *) foo_229 { return( "229"); }
+ (char *) foo_230 { return( "230"); }
+ (char *) foo_231 { return( "231"); }
+ (char *) foo_232 { return( "232"); }
+ (char *) foo_233 { return( "233"); }
+ (char *) foo_234 { return( "234"); }
+ (char *) foo_235 { return( "235"); }
+ (char *) foo_236 { return( "236"); }
+ (char *) foo_237 { return( "237"); }
+ (char *) foo_238 { return( "238"); }
+ (char *) foo_239 { return( "239"); }
+ (char *) foo_240 { return( "240"); }
+ (char *) foo_241 { return( "241"); }
+ (char *) foo_242 { return( "242"); }
+ (char *) foo_243 { return( "243"); }
+ (char *) foo_244 { return( "244"); }
+ (char *) foo_245 { return( "245"); }
+ (char *) foo_246 { return( "246"); }
+ (char *) foo_247 { return( "247"); }
+ (char *) foo_248 { return( "248"); }
+ (char *) foo_249 { return( "249"); }
+ (char *) foo_250 { return( "250"); }
+ (char *) foo_251 { return( "251"); }
+ (char *) foo_252 { return( "252"); }
+ (char *) foo_253 { return( "253"); }
+ (char *) foo_254 { return( "254"); }
+ (char *) foo_255 { return( "255"); }
+ (char *) foo_256 { return( "256"); }
+ (char *) foo_257 { return( "257"); }
+ (char *) foo_258 { return( "258"); }
+ (char *) foo_259 { return( "259"); }
+ (char *) foo_260 { return( "260"); }
+ (char *) foo_261 { return( "261"); }
+ (char *) foo_262 { return( "262"); }
+ (char *) foo_263 { return( "263"); }
+ (char *) foo_264 { return( "264"); }
+ (char *) foo_265 { return( "265"); }
+ (char *) foo_266 { return( "266"); }
+ (char *) foo_267 { return( "267"); }
+ (char *) foo_268 { return( "268"); }
+ (char *) foo_269 { return( "269"); }
+ (char *) foo_270 { return( "270"); }
+ (char *) foo_271 { return( "271"); }
+ (char *) foo_272 { return( "272"); }
+ (char *) foo_273 { return( "273"); }
+ (char *) foo_274 { return( "274"); }
+ (char *) foo_275 { return( "275"); }
+ (char *) foo_276 { return( "276"); }
+ (char *) foo_277 { return( "277"); }
+ (char *) foo_278 { return( "278"); }
+ (char *) foo_279 { return( "279"); }
+ (char *) foo_280 { return( "280"); }
+ (char *) foo_281 { return( "281"); }
+ (char *) foo_282 { return( "282"); }
+ (char *) foo_283 { return( "283"); }
+ (char *) foo_284 { return( "284"); }
+ (char *) foo_285 { return( "285"); }
+ (char *) foo_286 { return( "286"); }
+ (char *) foo_287 { return( "287"); }
+ (char *) foo_288 { return( "288"); }
+ (char *) foo_289 { return( "289"); }
+ (char *) foo_290 { return( "290"); }
+ (char *) foo_291 { return( "291"); }
+ (char *) foo_292 { return( "292"); }
+ (char *) foo_293 { return( "293"); }
+ (char *) foo_294 { return( "294"); }
+ (char *) foo_295 { return( "295"); }
+ (char *) foo_296 { return( "296"); }
+ (char *) foo_297 { return( "297"); }
+ (char *) foo_298 { return( "298"); }
+ (char *) foo_299 { return( "299"); }
+ (char *) foo_300 { return( "300"); }
+ (char *) foo_301 { return( "301"); }
+ (char *) foo_302 { return( "302"); }
+ (char *) foo_303 { return( "303"); }
+ (char *) foo_304 { return( "304"); }
+ (char *) foo_305 { return( "305"); }
+ (char *) foo_306 { return( "306"); }
+ (char *) foo_307 { return( "307"); }
+ (char *) foo_308 { return( "308"); }
+ (char *) foo_309 { return( "309"); }
+ (char *) foo_310 { return( "310"); }
+ (char *) foo_311 { return( "311"); }
+ (char *) foo_312 { return( "312"); }
+ (char *) foo_313 { return( "313"); }
+ (char *) foo_314 { return( "314"); }
+ (char *) foo_315 { return( "315"); }
+ (char *) foo_316 { return( "316"); }
+ (char *) foo_317 { return( "317"); }
+ (char *) foo_318 { return( "318"); }
+ (char *) foo_319 { return( "319"); }
+ (char *) foo_320 { return( "320"); }
+ (char *) foo_321 { return( "321"); }
+ (char *) foo_322 { return( "322"); }
+ (char *) foo_323 { return( "323"); }
+ (char *) foo_324 { return( "324"); }
+ (char *) foo_325 { return( "325"); }
+ (char *) foo_326 { return( "326"); }
+ (char *) foo_327 { return( "327"); }
+ (char *) foo_328 { return( "328"); }
+ (char *) foo_329 { return( "329"); }
+ (char *) foo_330 { return( "330"); }
+ (char *) foo_331 { return( "331"); }
+ (char *) foo_332 { return( "332"); }
+ (char *) foo_333 { return( "333"); }
+ (char *) foo_334 { return( "334"); }
+ (char *) foo_335 { return( "335"); }
+ (char *) foo_336 { return( "336"); }
+ (char *) foo_337 { return( "337"); }
+ (char *) foo_338 { return( "338"); }
+ (char *) foo_339 { return( "339"); }
+ (char *) foo_340 { return( "340"); }
+ (char *) foo_341 { return( "341"); }
+ (char *) foo_342 { return( "342"); }
+ (char *) foo_343 { return( "343"); }
+ (char *) foo_344 { return( "344"); }
+ (char *) foo_345 { return( "345"); }
+ (char *) foo_346 { return( "346"); }
+ (char *) foo_347 { return( "347"); }
+ (char *) foo_348 { return( "348"); }
+ (char *) foo_349 { return( "349"); }
+ (char *) foo_350 { return( "350"); }
+ (char *) foo_351 { return( "351"); }
+ (char *) foo_352 { return( "352"); }
+ (char *) foo_353 { return( "353"); }
+ (char *) foo_354 { return( "354"); }
+ (char *) foo_355 { return( "355"); }
+ (char *) foo_356 { return( "356"); }
+ (char *) foo_357 { return( "357"); }
+ (char *) foo_358 { return( "358"); }
+ (char *) foo_359 { return( "359"); }
+ (char *) foo_360 { return( "360"); }
+ (char *) foo_361 { return( "361"); }
+ (char *) foo_362 { return( "362"); }
+ (char *) foo_363 { return( "363"); }
+ (char *) foo_364 { return( "364"); }
+ (char *) foo_365 { return( "365"); }
+ (char *) foo_366 { return( "366"); }
+ (char *) foo_367 { return( "367"); }
+ (char *) foo_368 { return( "368"); }
+ (char *) foo_369 { return( "369"); }
+ (char *) foo_370 { return( "370"); }
+ (char *) foo_371 { return( "371"); }
+ (char *) foo_372 { return( "372"); }
+ (char *) foo_373 { return( "373"); }
+ (char *) foo_374 { return( "374"); }
+ (char *) foo_375 { return( "375"); }
+ (char *) foo_376 { return( "376"); }
+ (char *) foo_377 { return( "377"); }
+ (char *) foo_378 { return( "378"); }
+ (char *) foo_379 { return( "379"); }
+ (char *) foo_380 { return( "380"); }
+ (char *) foo_381 { return( "381"); }
+ (char *) foo_382 { return( "382"); }
+ (char *) foo_383 { return( "383"); }
+ (char *) foo_384 { return( "384"); }
+ (char *) foo_385 { return( "385"); }
+ (char *) foo_386 { return( "386"); }
+ (char *) foo_387 { return( "387"); }
+ (char *) foo_388 { return( "388"); }
+ (char *) foo_389 { return( "389"); }
+ (char *) foo_390 { return( "390"); }
+ (char *) foo_391 { return( "391"); }
+ (char *) foo_392 { return( "392"); }
+ (char *) foo_393 { return( "393"); }
+ (char *) foo_394 { return( "394"); }
+ (char *) foo_395 { return( "395"); }
+ (char *) foo_396 { return( "396"); }
+ (char *) foo_397 { return( "397"); }
+ (char *) foo_398 { return( "398"); }
+ (char *) foo_399 { return( "399"); }
+ (char *) foo_400 { return( "400"); }
+ (char *) foo_401 { return( "401"); }
+ (char *) foo_402 { return( "402"); }
+ (char *) foo_403 { return( "403"); }
+ (char *) foo_404 { return( "404"); }
+ (char *) foo_405 { return( "405"); }
+ (char *) foo_406 { return( "406"); }
+ (char *) foo_407 { return( "407"); }
+ (char *) foo_408 { return( "408"); }
+ (char *) foo_409 { return( "409"); }
+ (char *) foo_410 { return( "410"); }
+ (char *) foo_411 { return( "411"); }
+ (char *) foo_412 { return( "412"); }
+ (char *) foo_413 { return( "413"); }
+ (char *) foo_414 { return( "414"); }
+ (char *) foo_415 { return( "415"); }
+ (char *) foo_416 { return( "416"); }
+ (char *) foo_417 { return( "417"); }
+ (char *) foo_418 { return( "418"); }
+ (char *) foo_419 { return( "419"); }
+ (char *) foo_420 { return( "420"); }
+ (char *) foo_421 { return( "421"); }
+ (char *) foo_422 { return( "422"); }
+ (char *) foo_423 { return( "423"); }
+ (char *) foo_424 { return( "424"); }
+ (char *) foo_425 { return( "425"); }
+ (char *) foo_426 { return( "426"); }
+ (char *) foo_427 { return( "427"); }
+ (char *) foo_428 { return( "428"); }
+ (char *) foo_429 { return( "429"); }
+ (char *) foo_430 { return( "430"); }
+ (char *) foo_431 { return( "431"); }
+ (char *) foo_432 { return( "432"); }
+ (char *) foo_433 { return( "433"); }
+ (char *) foo_434 { return( "434"); }
+ (char *) foo_435 { return( "435"); }
+ (char *) foo_436 { return( "436"); }
+ (char *) foo_437 { return( "437"); }
+ (char *) foo_438 { return( "438"); }
+ (char *) foo_439 { return( "439"); }
+ (char *) foo_440 { return( "440"); }
+ (char *) foo_441 { return( "441"); }
+ (char *) foo_442 { return( "442"); }
+ (char *) foo_443 { return( "443"); }
+ (char *) foo_444 { return( "444"); }
+ (char *) foo_445 { return( "445"); }
+ (char *) foo_446 { return( "446"); }
+ (char *) foo_447 { return( "447"); }
+ (char *) foo_448 { return( "448"); }
+ (char *) foo_449 { return( "449"); }
+ (char *) foo_450 { return( "450"); }
+ (char *) foo_451 { return( "451"); }
+ (char *) foo_452 { return( "452"); }
+ (char *) foo_453 { return( "453"); }
+ (char *) foo_454 { return( "454"); }
+ (char *) foo_455 { return( "455"); }
+ (char *) foo_456 { return( "456"); }
+ (char *) foo_457 { return( "457"); }
+ (char *) foo_458 { return( "458"); }
+ (char *) foo_459 { return( "459"); }
+ (char *) foo_460 { return( "460"); }
+ (char *) foo_461 { return( "461"); }
+ (char *) foo_462 { return( "462"); }
+ (char *) foo_463 { return( "463"); }
+ (char *) foo_464 { return( "464"); }
+ (char *) foo_465 { return( "465"); }
+ (char *) foo_466 { return( "466"); }
+ (char *) foo_467 { return( "467"); }
+ (char *) foo_468 { return( "468"); }
+ (char *) foo_469 { return( "469"); }
+ (char *) foo_470 { return( "470"); }
+ (char *) foo_471 { return( "471"); }
+ (char *) foo_472 { return( "472"); }
+ (char *) foo_473 { return( "473"); }
+ (char *) foo_474 { return( "474"); }
+ (char *) foo_475 { return( "475"); }
+ (char *) foo_476 { return( "476"); }
+ (char *) foo_477 { return( "477"); }
+ (char *) foo_478 { return( "478"); }
+ (char *) foo_479 { return( "479"); }
+ (char *) foo_480 { return( "480"); }
+ (char *) foo_481 { return( "481"); }
+ (char *) foo_482 { return( "482"); }
+ (char *) foo_483 { return( "483"); }
+ (char *) foo_484 { return( "484"); }
+ (char *) foo_485 { return( "485"); }
+ (char *) foo_486 { return( "486"); }
+ (char *) foo_487 { return( "487"); }
+ (char *) foo_488 { return( "488"); }
+ (char *) foo_489 { return( "489"); }
+ (char *) foo_490 { return( "490"); }
+ (char *) foo_491 { return( "491"); }
+ (char *) foo_492 { return( "492"); }
+ (char *) foo_493 { return( "493"); }
+ (char *) foo_494 { return( "494"); }
+ (char *) foo_495 { return( "495"); }
+ (char *) foo_496 { return( "496"); }
+ (char *) foo_497 { return( "497"); }
+ (char *) foo_498 { return( "498"); }
+ (char *) foo_499 { return( "499"); }
+ (char *) foo_500 { return( "500"); }
+ (char *) foo_501 { return( "501"); }
+ (char *) foo_502 { return( "502"); }
+ (char *) foo_503 { return( "503"); }
+ (char *) foo_504 { return( "504"); }
+ (char *) foo_505 { return( "505"); }
+ (char *) foo_506 { return( "506"); }
+ (char *) foo_507 { return( "507"); }
+ (char *) foo_508 { return( "508"); }
+ (char *) foo_509 { return( "509"); }
+ (char *) foo_510 { return( "510"); }
+ (char *) foo_511 { return( "511"); }
+ (char *) foo_512 { return( "512"); }
+ (char *) foo_513 { return( "513"); }
+ (char *) foo_514 { return( "514"); }
+ (char *) foo_515 { return( "515"); }
+ (char *) foo_516 { return( "516"); }
+ (char *) foo_517 { return( "517"); }
+ (char *) foo_518 { return( "518"); }
+ (char *) foo_519 { return( "519"); }
+ (char *) foo_520 { return( "520"); }
+ (char *) foo_521 { return( "521"); }
+ (char *) foo_522 { return( "522"); }
+ (char *) foo_523 { return( "523"); }
+ (char *) foo_524 { return( "524"); }
+ (char *) foo_525 { return( "525"); }
+ (char *) foo_526 { return( "526"); }
+ (char *) foo_527 { return( "527"); }
+ (char *) foo_528 { return( "528"); }
+ (char *) foo_529 { return( "529"); }
+ (char *) foo_530 { return( "530"); }
+ (char *) foo_531 { return( "531"); }
+ (char *) foo_532 { return( "532"); }
+ (char *) foo_533 { return( "533"); }
+ (char *) foo_534 { return( "534"); }
+ (char *) foo_535 { return( "535"); }
+ (char *) foo_536 { return( "536"); }
+ (char *) foo_537 { return( "537"); }
+ (char *) foo_538 { return( "538"); }
+ (char *) foo_539 { return( "539"); }
+ (char *) foo_540 { return( "540"); }
+ (char *) foo_541 { return( "541"); }
+ (char *) foo_542 { return( "542"); }
+ (char *) foo_543 { return( "543"); }
+ (char *) foo_544 { return( "544"); }
+ (char *) foo_545 { return( "545"); }
+ (char *) foo_546 { return( "546"); }
+ (char *) foo_547 { return( "547"); }
+ (char *) foo_548 { return( "548"); }
+ (char *) foo_549 { return( "549"); }
+ (char *) foo_550 { return( "550"); }
+ (char *) foo_551 { return( "551"); }
+ (char *) foo_552 { return( "552"); }
+ (char *) foo_553 { return( "553"); }
+ (char *) foo_554 { return( "554"); }
+ (char *) foo_555 { return( "555"); }
+ (char *) foo_556 { return( "556"); }
+ (char *) foo_557 { return( "557"); }
+ (char *) foo_558 { return( "558"); }
+ (char *) foo_559 { return( "559"); }
+ (char *) foo_560 { return( "560"); }
+ (char *) foo_561 { return( "561"); }
+ (char *) foo_562 { return( "562"); }
+ (char *) foo_563 { return( "563"); }
+ (char *) foo_564 { return( "564"); }
+ (char *) foo_565 { return( "565"); }
+ (char *) foo_566 { return( "566"); }
+ (char *) foo_567 { return( "567"); }
+ (char *) foo_568 { return( "568"); }
+ (char *) foo_569 { return( "569"); }
+ (char *) foo_570 { return( "570"); }
+ (char *) foo_571 { return( "571"); }
+ (char *) foo_572 { return( "572"); }
+ (char *) foo_573 { return( "573"); }
+ (char *) foo_574 { return( "574"); }
+ (char *) foo_575 { return( "575"); }
+ (char *) foo_576 { return( "576"); }
+ (char *) foo_577 { return( "577"); }
+ (char *) foo_578 { return( "578"); }
+ (char *) foo_579 { return( "579"); }
+ (char *) foo_580 { return( "580"); }
+ (char *) foo_581 { return( "581"); }
+ (char *) foo_582 { return( "582"); }
+ (char *) foo_583 { return( "583"); }
+ (char *) foo_584 { return( "584"); }
+ (char *) foo_585 { return( "585"); }
+ (char *) foo_586 { return( "586"); }
+ (char *) foo_587 { return( "587"); }
+ (char *) foo_588 { return( "588"); }
+ (char *) foo_589 { return( "589"); }
+ (char *) foo_590 { return( "590"); }
+ (char *) foo_591 { return( "591"); }
+ (char *) foo_592 { return( "592"); }
+ (char *) foo_593 { return( "593"); }
+ (char *) foo_594 { return( "594"); }
+ (char *) foo_595 { return( "595"); }
+ (char *) foo_596 { return( "596"); }
+ (char *) foo_597 { return( "597"); }
+ (char *) foo_598 { return( "598"); }
+ (char *) foo_599 { return( "599"); }
+ (char *) foo_600 { return( "600"); }
+ (char *) foo_601 { return( "601"); }
+ (char *) foo_602 { return( "602"); }
+ (char *) foo_603 { return( "603"); }
+ (char *) foo_604 { return( "604"); }
+ (char *) foo_605 { return( "605"); }
+ (char *) foo_606 { return( "606"); }
+ (char *) foo_607 { return( "607"); }
+ (char *) foo_608 { return( "608"); }
+ (char *) foo_609 { return( "609"); }
+ (char *) foo_610 { return( "610"); }
+ (char *) foo_611 { return( "611"); }
+ (char *) foo_612 { return( "612"); }
+ (char *) foo_613 { return( "613"); }
+ (char *) foo_614 { return( "614"); }
+ (char *) foo_615 { return( "615"); }
+ (char *) foo_616 { return( "616"); }
+ (char *) foo_617 { return( "617"); }
+ (char *) foo_618 { return( "618"); }
+ (char *) foo_619 { return( "619"); }
+ (char *) foo_620 { return( "620"); }
+ (char *) foo_621 { return( "621"); }
+ (char *) foo_622 { return( "622"); }
+ (char *) foo_623 { return( "623"); }
+ (char *) foo_624 { return( "624"); }
+ (char *) foo_625 { return( "625"); }
+ (char *) foo_626 { return( "626"); }
+ (char *) foo_627 { return( "627"); }
+ (char *) foo_628 { return( "628"); }
+ (char *) foo_629 { return( "629"); }
+ (char *) foo_630 { return( "630"); }
+ (char *) foo_631 { return( "631"); }
+ (char *) foo_632 { return( "632"); }
+ (char *) foo_633 { return( "633"); }
+ (char *) foo_634 { return( "634"); }
+ (char *) foo_635 { return( "635"); }
+ (char *) foo_636 { return( "636"); }
+ (char *) foo_637 { return( "637"); }
+ (char *) foo_638 { return( "638"); }
+ (char *) foo_639 { return( "639"); }
+ (char *) foo_640 { return( "640"); }
+ (char *) foo_641 { return( "641"); }
+ (char *) foo_642 { return( "642"); }
+ (char *) foo_643 { return( "643"); }
+ (char *) foo_644 { return( "644"); }
+ (char *) foo_645 { return( "645"); }
+ (char *) foo_646 { return( "646"); }
+ (char *) foo_647 { return( "647"); }
+ (char *) foo_648 { return( "648"); }
+ (char *) foo_649 { return( "649"); }
+ (char *) foo_650 { return( "650"); }
+ (char *) foo_651 { return( "651"); }
+ (char *) foo_652 { return( "652"); }
+ (char *) foo_653 { return( "653"); }
+ (char *) foo_654 { return( "654"); }
+ (char *) foo_655 { return( "655"); }
+ (char *) foo_656 { return( "656"); }
+ (char *) foo_657 { return( "657"); }
+ (char *) foo_658 { return( "658"); }
+ (char *) foo_659 { return( "659"); }
+ (char *) foo_660 { return( "660"); }
+ (char *) foo_661 { return( "661"); }
+ (char *) foo_662 { return( "662"); }
+ (char *) foo_663 { return( "663"); }
+ (char *) foo_664 { return( "664"); }
+ (char *) foo_665 { return( "665"); }
+ (char *) foo_666 { return( "666"); }
+ (char *) foo_667 { return( "667"); }
+ (char *) foo_668 { return( "668"); }
+ (char *) foo_669 { return( "669"); }
+ (char *) foo_670 { return( "670"); }
+ (char *) foo_671 { return( "671"); }
+ (char *) foo_672 { return( "672"); }
+ (char *) foo_673 { return( "673"); }
+ (char *) foo_674 { return( "674"); }
+ (char *) foo_675 { return( "675"); }
+ (char *) foo_676 { return( "676"); }
+ (char *) foo_677 { return( "677"); }
+ (char *) foo_678 { return( "678"); }
+ (char *) foo_679 { return( "679"); }
+ (char *) foo_680 { return( "680"); }
+ (char *) foo_681 { return( "681"); }
+ (char *) foo_682 { return( "682"); }
+ (char *) foo_683 { return( "683"); }
+ (char *) foo_684 { return( "684"); }
+ (char *) foo_685 { return( "685"); }
+ (char *) foo_686 { return( "686"); }
+ (char *) foo_687 { return( "687"); }
+ (char *) foo_688 { return( "688"); }
+ (char *) foo_689 { return( "689"); }
+ (char *) foo_690 { return( "690"); }
+ (char *) foo_691 { return( "691"); }
+ (char *) foo_692 { return( "692"); }
+ (char *) foo_693 { return( "693"); }
+ (char *) foo_694 { return( "694"); }
+ (char *) foo_695 { return( "695"); }
+ (char *) foo_696 { return( "696"); }
+ (char *) foo_697 { return( "697"); }
+ (char *) foo_698 { return( "698"); }
+ (char *) foo_699 { return( "699"); }
+ (char *) foo_700 { return( "700"); }
+ (char *) foo_701 { return( "701"); }
+ (char *) foo_702 { return( "702"); }
+ (char *) foo_703 { return( "703"); }
+ (char *) foo_704 { return( "704"); }
+ (char *) foo_705 { return( "705"); }
+ (char *) foo_706 { return( "706"); }
+ (char *) foo_707 { return( "707"); }
+ (char *) foo_708 { return( "708"); }
+ (char *) foo_709 { return( "709"); }
+ (char *) foo_710 { return( "710"); }
+ (char *) foo_711 { return( "711"); }
+ (char *) foo_712 { return( "712"); }
+ (char *) foo_713 { return( "713"); }
+ (char *) foo_714 { return( "714"); }
+ (char *) foo_715 { return( "715"); }
+ (char *) foo_716 { return( "716"); }
+ (char *) foo_717 { return( "717"); }
+ (char *) foo_718 { return( "718"); }
+ (char *) foo_719 { return( "719"); }
+ (char *) foo_720 { return( "720"); }
+ (char *) foo_721 { return( "721"); }
+ (char *) foo_722 { return( "722"); }
+ (char *) foo_723 { return( "723"); }
+ (char *) foo_724 { return( "724"); }
+ (char *) foo_725 { return( "725"); }
+ (char *) foo_726 { return( "726"); }
+ (char *) foo_727 { return( "727"); }
+ (char *) foo_728 { return( "728"); }
+ (char *) foo_729 { return( "729"); }
+ (char *) foo_730 { return( "730"); }
+ (char *) foo_731 { return( "731"); }
+ (char *) foo_732 { return( "732"); }
+ (char *) foo_733 { return( "733"); }
+ (char *) foo_734 { return( "734"); }
+ (char *) foo_735 { return( "735"); }
+ (char *) foo_736 { return( "736"); }
+ (char *) foo_737 { return( "737"); }
+ (char *) foo_738 { return( "738"); }
+ (char *) foo_739 { return( "739"); }
+ (char *) foo_740 { return( "740"); }
+ (char *) foo_741 { return( "741"); }
+ (char *) foo_742 { return( "742"); }
+ (char *) foo_743 { return( "743"); }
+ (char *) foo_744 { return( "744"); }
+ (char *) foo_745 { return( "745"); }
+ (char *) foo_746 { return( "746"); }
+ (char *) foo_747 { return( "747"); }
+ (char *) foo_748 { return( "748"); }
+ (char *) foo_749 { return( "749"); }
+ (char *) foo_750 { return( "750"); }
+ (char *) foo_751 { return( "751"); }
+ (char *) foo_752 { return( "752"); }
+ (char *) foo_753 { return( "753"); }
+ (char *) foo_754 { return( "754"); }
+ (char *) foo_755 { return( "755"); }
+ (char *) foo_756 { return( "756"); }
+ (char *) foo_757 { return( "757"); }
+ (char *) foo_758 { return( "758"); }
+ (char *) foo_759 { return( "759"); }
+ (char *) foo_760 { return( "760"); }
+ (char *) foo_761 { return( "761"); }
+ (char *) foo_762 { return( "762"); }
+ (char *) foo_763 { return( "763"); }
+ (char *) foo_764 { return( "764"); }
+ (char *) foo_765 { return( "765"); }
+ (char *) foo_766 { return( "766"); }
+ (char *) foo_767 { return( "767"); }
+ (char *) foo_768 { return( "768"); }
+ (char *) foo_769 { return( "769"); }
+ (char *) foo_770 { return( "770"); }
+ (char *) foo_771 { return( "771"); }
+ (char *) foo_772 { return( "772"); }
+ (char *) foo_773 { return( "773"); }
+ (char *) foo_774 { return( "774"); }
+ (char *) foo_775 { return( "775"); }
+ (char *) foo_776 { return( "776"); }
+ (char *) foo_777 { return( "777"); }
+ (char *) foo_778 { return( "778"); }
+ (char *) foo_779 { return( "779"); }
+ (char *) foo_780 { return( "780"); }
+ (char *) foo_781 { return( "781"); }
+ (char *) foo_782 { return( "782"); }
+ (char *) foo_783 { return( "783"); }
+ (char *) foo_784 { return( "784"); }
+ (char *) foo_785 { return( "785"); }
+ (char *) foo_786 { return( "786"); }
+ (char *) foo_787 { return( "787"); }
+ (char *) foo_788 { return( "788"); }
+ (char *) foo_789 { return( "789"); }
+ (char *) foo_790 { return( "790"); }
+ (char *) foo_791 { return( "791"); }
+ (char *) foo_792 { return( "792"); }
+ (char *) foo_793 { return( "793"); }
+ (char *) foo_794 { return( "794"); }
+ (char *) foo_795 { return( "795"); }
+ (char *) foo_796 { return( "796"); }
+ (char *) foo_797 { return( "797"); }
+ (char *) foo_798 { return( "798"); }
+ (char *) foo_799 { return( "799"); }
+ (char *) foo_800 { return( "800"); }
+ (char *) foo_801 { return( "801"); }
+ (char *) foo_802 { return( "802"); }
+ (char *) foo_803 { return( "803"); }
+ (char *) foo_804 { return( "804"); }
+ (char *) foo_805 { return( "805"); }
+ (char *) foo_806 { return( "806"); }
+ (char *) foo_807 { return( "807"); }
+ (char *) foo_808 { return( "808"); }
+ (char *) foo_809 { return( "809"); }
+ (char *) foo_810 { return( "810"); }
+ (char *) foo_811 { return( "811"); }
+ (char *) foo_812 { return( "812"); }
+ (char *) foo_813 { return( "813"); }
+ (char *) foo_814 { return( "814"); }
+ (char *) foo_815 { return( "815"); }
+ (char *) foo_816 { return( "816"); }
+ (char *) foo_817 { return( "817"); }
+ (char *) foo_818 { return( "818"); }
+ (char *) foo_819 { return( "819"); }
+ (char *) foo_820 { return( "820"); }
+ (char *) foo_821 { return( "821"); }
+ (char *) foo_822 { return( "822"); }
+ (char *) foo_823 { return( "823"); }
+ (char *) foo_824 { return( "824"); }
+ (char *) foo_825 { return( "825"); }
+ (char *) foo_826 { return( "826"); }
+ (char *) foo_827 { return( "827"); }
+ (char *) foo_828 { return( "828"); }
+ (char *) foo_829 { return( "829"); }
+ (char *) foo_830 { return( "830"); }
+ (char *) foo_831 { return( "831"); }
+ (char *) foo_832 { return( "832"); }
+ (char *) foo_833 { return( "833"); }
+ (char *) foo_834 { return( "834"); }
+ (char *) foo_835 { return( "835"); }
+ (char *) foo_836 { return( "836"); }
+ (char *) foo_837 { return( "837"); }
+ (char *) foo_838 { return( "838"); }
+ (char *) foo_839 { return( "839"); }
+ (char *) foo_840 { return( "840"); }
+ (char *) foo_841 { return( "841"); }
+ (char *) foo_842 { return( "842"); }
+ (char *) foo_843 { return( "843"); }
+ (char *) foo_844 { return( "844"); }
+ (char *) foo_845 { return( "845"); }
+ (char *) foo_846 { return( "846"); }
+ (char *) foo_847 { return( "847"); }
+ (char *) foo_848 { return( "848"); }
+ (char *) foo_849 { return( "849"); }
+ (char *) foo_850 { return( "850"); }
+ (char *) foo_851 { return( "851"); }
+ (char *) foo_852 { return( "852"); }
+ (char *) foo_853 { return( "853"); }
+ (char *) foo_854 { return( "854"); }
+ (char *) foo_855 { return( "855"); }
+ (char *) foo_856 { return( "856"); }
+ (char *) foo_857 { return( "857"); }
+ (char *) foo_858 { return( "858"); }
+ (char *) foo_859 { return( "859"); }
+ (char *) foo_860 { return( "860"); }
+ (char *) foo_861 { return( "861"); }
+ (char *) foo_862 { return( "862"); }
+ (char *) foo_863 { return( "863"); }
+ (char *) foo_864 { return( "864"); }
+ (char *) foo_865 { return( "865"); }
+ (char *) foo_866 { return( "866"); }
+ (char *) foo_867 { return( "867"); }
+ (char *) foo_868 { return( "868"); }
+ (char *) foo_869 { return( "869"); }
+ (char *) foo_870 { return( "870"); }
+ (char *) foo_871 { return( "871"); }
+ (char *) foo_872 { return( "872"); }
+ (char *) foo_873 { return( "873"); }
+ (char *) foo_874 { return( "874"); }
+ (char *) foo_875 { return( "875"); }
+ (char *) foo_876 { return( "876"); }
+ (char *) foo_877 { return( "877"); }
+ (char *) foo_878 { return( "878"); }
+ (char *) foo_879 { return( "879"); }
+ (char *) foo_880 { return( "880"); }
+ (char *) foo_881 { return( "881"); }
+ (char *) foo_882 { return( "882"); }
+ (char *) foo_883 { return( "883"); }
+ (char *) foo_884 { return( "884"); }
+ (char *) foo_885 { return( "885"); }
+ (char *) foo_886 { return( "886"); }
+ (char *) foo_887 { return( "887"); }
+ (char *) foo_888 { return( "888"); }
+ (char *) foo_889 { return( "889"); }
+ (char *) foo_890 { return( "890"); }
+ (char *) foo_891 { return( "891"); }
+ (char *) foo_892 { return( "892"); }
+ (char *) foo_893 { return( "893"); }
+ (char *) foo_894 { return( "894"); }
+ (char *) foo_895 { return( "895"); }
+ (char *) foo_896 { return( "896"); }
+ (char *) foo_897 { return( "897"); }
+ (char *) foo_898 { return( "898"); }
+ (char *) foo_899 { return( "899"); }
+ (char *) foo_900 { return( "900"); }
+ (char *) foo_901 { return( "901"); }
+ (char *) foo_902 { return( "902"); }
+ (char *) foo_903 { return( "903"); }
+ (char *) foo_904 { return( "904"); }
+ (char *) foo_905 { return( "905"); }
+ (char *) foo_906 { return( "906"); }
+ (char *) foo_907 { return( "907"); }
+ (char *) foo_908 { return( "908"); }
+ (char *) foo_909 { return( "909"); }
+ (char *) foo_910 { return( "910"); }
+ (char *) foo_911 { return( "911"); }
+ (char *) foo_912 { return( "912"); }
+ (char *) foo_913 { return( "913"); }
+ (char *) foo_914 { return( "914"); }
+ (char *) foo_915 { return( "915"); }
+ (char *) foo_916 { return( "916"); }
+ (char *) foo_917 { return( "917"); }
+ (char *) foo_918 { return( "918"); }
+ (char *) foo_919 { return( "919"); }
+ (char *) foo_920 { return( "920"); }
+ (char *) foo_921 { return( "921"); }
+ (char *) foo_922 { return( "922"); }
+ (char *) foo_923 { return( "923"); }
+ (char *) foo_924 { return( "924"); }
+ (char *) foo_925 { return( "925"); }
+ (char *) foo_926 { return( "926"); }
+ (char *) foo_927 { return( "927"); }
+ (char *) foo_928 { return( "928"); }
+ (char *) foo_929 { return( "929"); }
+ (char *) foo_930 { return( "930"); }
+ (char *) foo_931 { return( "931"); }
+ (char *) foo_932 { return( "932"); }
+ (char *) foo_933 { return( "933"); }
+ (char *) foo_934 { return( "934"); }
+ (char *) foo_935 { return( "935"); }
+ (char *) foo_936 { return( "936"); }
+ (char *) foo_937 { return( "937"); }
+ (char *) foo_938 { return( "938"); }
+ (char *) foo_939 { return( "939"); }
+ (char *) foo_940 { return( "940"); }
+ (char *) foo_941 { return( "941"); }
+ (char *) foo_942 { return( "942"); }
+ (char *) foo_943 { return( "943"); }
+ (char *) foo_944 { return( "944"); }
+ (char *) foo_945 { return( "945"); }
+ (char *) foo_946 { return( "946"); }
+ (char *) foo_947 { return( "947"); }
+ (char *) foo_948 { return( "948"); }
+ (char *) foo_949 { return( "949"); }
+ (char *) foo_950 { return( "950"); }
+ (char *) foo_951 { return( "951"); }
+ (char *) foo_952 { return( "952"); }
+ (char *) foo_953 { return( "953"); }
+ (char *) foo_954 { return( "954"); }
+ (char *) foo_955 { return( "955"); }
+ (char *) foo_956 { return( "956"); }
+ (char *) foo_957 { return( "957"); }
+ (char *) foo_958 { return( "958"); }
+ (char *) foo_959 { return( "959"); }
+ (char *) foo_960 { return( "960"); }
+ (char *) foo_961 { return( "961"); }
+ (char *) foo_962 { return( "962"); }
+ (char *) foo_963 { return( "963"); }
+ (char *) foo_964 { return( "964"); }
+ (char *) foo_965 { return( "965"); }
+ (char *) foo_966 { return( "966"); }
+ (char *) foo_967 { return( "967"); }
+ (char *) foo_968 { return( "968"); }
+ (char *) foo_969 { return( "969"); }
+ (char *) foo_970 { return( "970"); }
+ (char *) foo_971 { return( "971"); }
+ (char *) foo_972 { return( "972"); }
+ (char *) foo_973 { return( "973"); }
+ (char *) foo_974 { return( "974"); }
+ (char *) foo_975 { return( "975"); }
+ (char *) foo_976 { return( "976"); }
+ (char *) foo_977 { return( "977"); }
+ (char *) foo_978 { return( "978"); }
+ (char *) foo_979 { return( "979"); }
+ (char *) foo_980 { return( "980"); }
+ (char *) foo_981 { return( "981"); }
+ (char *) foo_982 { return( "982"); }
+ (char *) foo_983 { return( "983"); }
+ (char *) foo_984 { return( "984"); }
+ (char *) foo_985 { return( "985"); }
+ (char *) foo_986 { return( "986"); }
+ (char *) foo_987 { return( "987"); }
+ (char *) foo_988 { return( "988"); }
+ (char *) foo_989 { return( "989"); }
+ (char *) foo_990 { return( "990"); }
+ (char *) foo_991 { return( "991"); }
+ (char *) foo_992 { return( "992"); }
+ (char *) foo_993 { return( "993"); }
+ (char *) foo_994 { return( "994"); }
+ (char *) foo_995 { return( "995"); }
+ (char *) foo_996 { return( "996"); }
+ (char *) foo_997 { return( "997"); }
+ (char *) foo_998 { return( "998"); }
+ (char *) foo_999 { return( "999"); }
+ (char *) foo_1000 { return( "1000"); }
+ (char *) foo_1001 { return( "1001"); }
+ (char *) foo_1002 { return( "1002"); }
+ (char *) foo_1003 { return( "1003"); }
+ (char *) foo_1004 { return( "1004"); }
+ (char *) foo_1005 { return( "1005"); }
+ (char *) foo_1006 { return( "1006"); }
+ (char *) foo_1007 { return( "1007"); }
+ (char *) foo_1008 { return( "1008"); }
+ (char *) foo_1009 { return( "1009"); }
+ (char *) foo_1010 { return( "1010"); }
+ (char *) foo_1011 { return( "1011"); }
+ (char *) foo_1012 { return( "1012"); }
+ (char *) foo_1013 { return( "1013"); }
+ (char *) foo_1014 { return( "1014"); }
+ (char *) foo_1015 { return( "1015"); }
+ (char *) foo_1016 { return( "1016"); }
+ (char *) foo_1017 { return( "1017"); }
+ (char *) foo_1018 { return( "1018"); }
+ (char *) foo_1019 { return( "1019"); }
+ (char *) foo_1020 { return( "1020"); }
+ (char *) foo_1021 { return( "1021"); }
+ (char *) foo_1022 { return( "1022"); }
+ (char *) foo_1023 { return( "1023"); }


+ (void) run:(id) unused
{
   char  *name;

   name = [NSThread mainThread] == [NSThread currentThread] ? "a" : "b";

   wait_for_other_thread( name);

   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_0)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_2)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_3)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_4)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_5)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_6)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_7)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_8)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_9)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_10)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_11)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_12)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_13)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_14)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_15)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_16)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_17)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_18)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_19)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_20)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_21)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_22)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_23)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_24)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_25)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_26)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_27)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_28)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_29)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_30)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_31)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_32)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_33)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_34)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_35)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_36)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_37)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_38)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_39)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_40)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_41)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_42)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_43)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_44)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_45)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_46)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_47)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_48)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_49)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_50)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_51)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_52)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_53)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_54)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_55)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_56)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_57)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_58)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_59)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_60)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_61)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_62)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_63)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_64)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_65)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_66)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_67)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_68)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_69)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_70)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_71)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_72)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_73)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_74)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_75)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_76)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_77)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_78)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_79)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_80)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_81)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_82)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_83)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_84)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_85)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_86)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_87)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_88)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_89)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_90)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_91)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_92)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_93)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_94)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_95)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_96)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_97)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_98)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_99)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_100)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_101)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_102)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_103)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_104)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_105)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_106)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_107)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_108)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_109)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_110)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_111)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_112)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_113)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_114)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_115)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_116)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_117)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_118)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_119)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_120)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_121)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_122)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_123)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_124)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_125)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_126)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_127)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_128)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_129)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_130)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_131)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_132)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_133)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_134)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_135)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_136)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_137)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_138)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_139)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_140)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_141)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_142)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_143)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_144)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_145)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_146)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_147)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_148)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_149)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_150)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_151)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_152)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_153)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_154)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_155)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_156)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_157)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_158)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_159)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_160)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_161)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_162)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_163)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_164)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_165)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_166)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_167)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_168)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_169)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_170)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_171)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_172)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_173)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_174)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_175)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_176)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_177)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_178)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_179)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_180)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_181)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_182)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_183)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_184)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_185)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_186)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_187)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_188)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_189)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_190)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_191)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_192)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_193)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_194)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_195)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_196)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_197)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_198)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_199)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_200)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_201)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_202)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_203)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_204)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_205)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_206)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_207)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_208)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_209)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_210)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_211)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_212)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_213)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_214)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_215)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_216)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_217)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_218)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_219)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_220)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_221)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_222)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_223)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_224)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_225)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_226)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_227)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_228)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_229)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_230)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_231)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_232)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_233)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_234)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_235)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_236)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_237)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_238)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_239)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_240)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_241)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_242)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_243)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_244)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_245)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_246)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_247)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_248)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_249)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_250)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_251)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_252)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_253)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_254)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_255)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_256)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_257)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_258)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_259)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_260)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_261)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_262)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_263)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_264)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_265)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_266)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_267)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_268)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_269)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_270)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_271)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_272)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_273)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_274)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_275)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_276)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_277)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_278)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_279)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_280)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_281)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_282)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_283)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_284)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_285)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_286)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_287)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_288)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_289)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_290)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_291)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_292)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_293)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_294)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_295)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_296)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_297)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_298)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_299)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_300)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_301)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_302)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_303)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_304)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_305)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_306)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_307)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_308)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_309)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_310)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_311)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_312)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_313)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_314)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_315)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_316)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_317)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_318)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_319)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_320)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_321)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_322)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_323)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_324)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_325)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_326)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_327)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_328)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_329)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_330)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_331)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_332)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_333)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_334)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_335)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_336)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_337)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_338)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_339)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_340)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_341)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_342)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_343)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_344)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_345)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_346)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_347)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_348)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_349)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_350)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_351)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_352)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_353)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_354)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_355)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_356)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_357)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_358)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_359)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_360)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_361)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_362)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_363)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_364)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_365)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_366)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_367)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_368)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_369)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_370)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_371)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_372)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_373)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_374)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_375)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_376)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_377)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_378)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_379)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_380)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_381)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_382)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_383)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_384)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_385)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_386)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_387)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_388)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_389)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_390)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_391)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_392)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_393)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_394)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_395)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_396)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_397)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_398)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_399)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_400)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_401)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_402)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_403)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_404)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_405)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_406)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_407)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_408)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_409)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_410)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_411)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_412)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_413)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_414)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_415)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_416)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_417)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_418)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_419)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_420)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_421)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_422)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_423)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_424)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_425)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_426)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_427)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_428)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_429)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_430)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_431)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_432)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_433)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_434)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_435)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_436)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_437)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_438)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_439)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_440)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_441)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_442)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_443)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_444)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_445)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_446)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_447)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_448)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_449)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_450)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_451)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_452)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_453)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_454)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_455)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_456)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_457)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_458)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_459)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_460)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_461)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_462)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_463)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_464)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_465)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_466)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_467)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_468)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_469)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_470)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_471)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_472)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_473)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_474)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_475)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_476)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_477)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_478)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_479)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_480)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_481)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_482)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_483)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_484)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_485)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_486)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_487)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_488)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_489)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_490)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_491)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_492)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_493)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_494)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_495)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_496)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_497)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_498)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_499)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_500)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_501)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_502)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_503)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_504)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_505)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_506)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_507)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_508)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_509)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_510)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_511)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_512)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_513)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_514)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_515)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_516)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_517)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_518)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_519)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_520)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_521)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_522)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_523)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_524)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_525)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_526)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_527)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_528)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_529)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_530)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_531)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_532)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_533)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_534)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_535)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_536)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_537)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_538)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_539)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_540)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_541)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_542)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_543)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_544)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_545)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_546)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_547)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_548)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_549)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_550)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_551)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_552)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_553)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_554)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_555)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_556)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_557)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_558)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_559)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_560)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_561)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_562)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_563)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_564)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_565)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_566)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_567)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_568)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_569)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_570)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_571)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_572)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_573)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_574)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_575)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_576)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_577)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_578)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_579)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_580)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_581)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_582)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_583)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_584)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_585)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_586)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_587)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_588)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_589)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_590)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_591)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_592)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_593)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_594)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_595)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_596)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_597)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_598)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_599)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_600)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_601)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_602)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_603)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_604)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_605)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_606)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_607)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_608)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_609)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_610)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_611)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_612)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_613)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_614)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_615)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_616)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_617)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_618)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_619)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_620)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_621)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_622)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_623)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_624)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_625)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_626)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_627)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_628)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_629)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_630)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_631)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_632)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_633)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_634)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_635)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_636)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_637)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_638)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_639)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_640)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_641)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_642)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_643)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_644)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_645)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_646)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_647)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_648)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_649)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_650)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_651)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_652)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_653)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_654)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_655)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_656)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_657)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_658)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_659)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_660)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_661)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_662)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_663)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_664)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_665)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_666)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_667)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_668)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_669)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_670)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_671)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_672)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_673)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_674)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_675)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_676)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_677)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_678)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_679)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_680)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_681)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_682)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_683)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_684)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_685)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_686)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_687)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_688)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_689)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_690)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_691)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_692)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_693)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_694)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_695)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_696)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_697)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_698)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_699)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_700)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_701)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_702)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_703)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_704)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_705)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_706)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_707)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_708)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_709)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_710)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_711)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_712)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_713)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_714)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_715)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_716)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_717)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_718)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_719)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_720)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_721)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_722)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_723)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_724)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_725)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_726)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_727)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_728)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_729)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_730)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_731)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_732)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_733)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_734)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_735)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_736)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_737)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_738)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_739)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_740)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_741)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_742)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_743)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_744)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_745)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_746)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_747)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_748)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_749)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_750)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_751)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_752)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_753)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_754)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_755)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_756)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_757)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_758)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_759)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_760)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_761)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_762)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_763)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_764)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_765)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_766)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_767)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_768)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_769)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_770)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_771)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_772)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_773)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_774)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_775)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_776)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_777)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_778)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_779)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_780)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_781)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_782)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_783)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_784)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_785)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_786)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_787)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_788)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_789)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_790)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_791)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_792)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_793)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_794)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_795)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_796)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_797)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_798)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_799)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_800)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_801)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_802)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_803)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_804)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_805)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_806)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_807)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_808)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_809)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_810)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_811)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_812)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_813)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_814)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_815)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_816)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_817)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_818)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_819)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_820)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_821)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_822)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_823)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_824)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_825)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_826)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_827)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_828)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_829)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_830)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_831)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_832)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_833)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_834)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_835)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_836)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_837)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_838)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_839)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_840)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_841)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_842)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_843)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_844)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_845)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_846)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_847)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_848)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_849)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_850)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_851)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_852)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_853)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_854)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_855)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_856)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_857)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_858)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_859)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_860)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_861)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_862)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_863)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_864)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_865)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_866)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_867)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_868)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_869)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_870)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_871)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_872)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_873)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_874)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_875)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_876)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_877)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_878)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_879)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_880)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_881)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_882)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_883)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_884)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_885)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_886)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_887)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_888)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_889)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_890)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_891)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_892)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_893)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_894)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_895)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_896)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_897)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_898)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_899)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_900)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_901)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_902)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_903)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_904)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_905)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_906)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_907)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_908)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_909)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_910)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_911)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_912)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_913)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_914)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_915)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_916)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_917)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_918)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_919)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_920)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_921)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_922)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_923)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_924)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_925)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_926)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_927)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_928)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_929)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_930)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_931)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_932)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_933)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_934)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_935)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_936)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_937)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_938)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_939)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_940)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_941)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_942)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_943)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_944)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_945)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_946)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_947)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_948)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_949)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_950)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_951)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_952)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_953)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_954)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_955)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_956)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_957)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_958)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_959)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_960)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_961)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_962)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_963)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_964)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_965)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_966)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_967)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_968)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_969)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_970)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_971)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_972)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_973)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_974)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_975)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_976)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_977)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_978)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_979)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_980)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_981)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_982)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_983)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_984)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_985)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_986)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_987)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_988)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_989)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_990)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_991)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_992)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_993)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_994)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_995)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_996)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_997)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_998)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_999)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1000)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1001)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1002)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1003)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1004)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1005)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1006)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1007)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1008)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1009)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1010)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1011)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1012)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1013)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1014)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1015)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1016)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1017)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1018)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1019)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1020)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1021)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1022)], self, @selector( unused)));
   fprintf( FP, "%s: %s\n", name, (char *) MulleObjCIMPCall0( [self methodForSelector:@selector( foo_1023)], self, @selector( unused)));
}

@end



int main( void)
{
   NSThread    *thread;

   thread = [[[NSThread alloc] initWithTarget:[Foo class]
                                     selector:@selector( run:)
                                       object:nil] autorelease];
   [thread mulleStart];
   [Foo run:nil];
   [thread mulleJoin];

   return( 0);
}