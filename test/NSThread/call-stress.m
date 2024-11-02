#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif

// The point of this test is to get the method cache to grow. One of the
// threads will then operate for a small time on the old cache and the other
// on the fresh cache. If there were problems with that we would get a
// wront method call and therefore also a wrong output sequence.
// Or maybe even a crash.


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

   fprintf( FP, "%s: %s\n", name, [self foo_0]);
   fprintf( FP, "%s: %s\n", name, [self foo_1]);
   fprintf( FP, "%s: %s\n", name, [self foo_2]);
   fprintf( FP, "%s: %s\n", name, [self foo_3]);
   fprintf( FP, "%s: %s\n", name, [self foo_4]);
   fprintf( FP, "%s: %s\n", name, [self foo_5]);
   fprintf( FP, "%s: %s\n", name, [self foo_6]);
   fprintf( FP, "%s: %s\n", name, [self foo_7]);
   fprintf( FP, "%s: %s\n", name, [self foo_8]);
   fprintf( FP, "%s: %s\n", name, [self foo_9]);
   fprintf( FP, "%s: %s\n", name, [self foo_10]);
   fprintf( FP, "%s: %s\n", name, [self foo_11]);
   fprintf( FP, "%s: %s\n", name, [self foo_12]);
   fprintf( FP, "%s: %s\n", name, [self foo_13]);
   fprintf( FP, "%s: %s\n", name, [self foo_14]);
   fprintf( FP, "%s: %s\n", name, [self foo_15]);
   fprintf( FP, "%s: %s\n", name, [self foo_16]);
   fprintf( FP, "%s: %s\n", name, [self foo_17]);
   fprintf( FP, "%s: %s\n", name, [self foo_18]);
   fprintf( FP, "%s: %s\n", name, [self foo_19]);
   fprintf( FP, "%s: %s\n", name, [self foo_20]);
   fprintf( FP, "%s: %s\n", name, [self foo_21]);
   fprintf( FP, "%s: %s\n", name, [self foo_22]);
   fprintf( FP, "%s: %s\n", name, [self foo_23]);
   fprintf( FP, "%s: %s\n", name, [self foo_24]);
   fprintf( FP, "%s: %s\n", name, [self foo_25]);
   fprintf( FP, "%s: %s\n", name, [self foo_26]);
   fprintf( FP, "%s: %s\n", name, [self foo_27]);
   fprintf( FP, "%s: %s\n", name, [self foo_28]);
   fprintf( FP, "%s: %s\n", name, [self foo_29]);
   fprintf( FP, "%s: %s\n", name, [self foo_30]);
   fprintf( FP, "%s: %s\n", name, [self foo_31]);
   fprintf( FP, "%s: %s\n", name, [self foo_32]);
   fprintf( FP, "%s: %s\n", name, [self foo_33]);
   fprintf( FP, "%s: %s\n", name, [self foo_34]);
   fprintf( FP, "%s: %s\n", name, [self foo_35]);
   fprintf( FP, "%s: %s\n", name, [self foo_36]);
   fprintf( FP, "%s: %s\n", name, [self foo_37]);
   fprintf( FP, "%s: %s\n", name, [self foo_38]);
   fprintf( FP, "%s: %s\n", name, [self foo_39]);
   fprintf( FP, "%s: %s\n", name, [self foo_40]);
   fprintf( FP, "%s: %s\n", name, [self foo_41]);
   fprintf( FP, "%s: %s\n", name, [self foo_42]);
   fprintf( FP, "%s: %s\n", name, [self foo_43]);
   fprintf( FP, "%s: %s\n", name, [self foo_44]);
   fprintf( FP, "%s: %s\n", name, [self foo_45]);
   fprintf( FP, "%s: %s\n", name, [self foo_46]);
   fprintf( FP, "%s: %s\n", name, [self foo_47]);
   fprintf( FP, "%s: %s\n", name, [self foo_48]);
   fprintf( FP, "%s: %s\n", name, [self foo_49]);
   fprintf( FP, "%s: %s\n", name, [self foo_50]);
   fprintf( FP, "%s: %s\n", name, [self foo_51]);
   fprintf( FP, "%s: %s\n", name, [self foo_52]);
   fprintf( FP, "%s: %s\n", name, [self foo_53]);
   fprintf( FP, "%s: %s\n", name, [self foo_54]);
   fprintf( FP, "%s: %s\n", name, [self foo_55]);
   fprintf( FP, "%s: %s\n", name, [self foo_56]);
   fprintf( FP, "%s: %s\n", name, [self foo_57]);
   fprintf( FP, "%s: %s\n", name, [self foo_58]);
   fprintf( FP, "%s: %s\n", name, [self foo_59]);
   fprintf( FP, "%s: %s\n", name, [self foo_60]);
   fprintf( FP, "%s: %s\n", name, [self foo_61]);
   fprintf( FP, "%s: %s\n", name, [self foo_62]);
   fprintf( FP, "%s: %s\n", name, [self foo_63]);
   fprintf( FP, "%s: %s\n", name, [self foo_64]);
   fprintf( FP, "%s: %s\n", name, [self foo_65]);
   fprintf( FP, "%s: %s\n", name, [self foo_66]);
   fprintf( FP, "%s: %s\n", name, [self foo_67]);
   fprintf( FP, "%s: %s\n", name, [self foo_68]);
   fprintf( FP, "%s: %s\n", name, [self foo_69]);
   fprintf( FP, "%s: %s\n", name, [self foo_70]);
   fprintf( FP, "%s: %s\n", name, [self foo_71]);
   fprintf( FP, "%s: %s\n", name, [self foo_72]);
   fprintf( FP, "%s: %s\n", name, [self foo_73]);
   fprintf( FP, "%s: %s\n", name, [self foo_74]);
   fprintf( FP, "%s: %s\n", name, [self foo_75]);
   fprintf( FP, "%s: %s\n", name, [self foo_76]);
   fprintf( FP, "%s: %s\n", name, [self foo_77]);
   fprintf( FP, "%s: %s\n", name, [self foo_78]);
   fprintf( FP, "%s: %s\n", name, [self foo_79]);
   fprintf( FP, "%s: %s\n", name, [self foo_80]);
   fprintf( FP, "%s: %s\n", name, [self foo_81]);
   fprintf( FP, "%s: %s\n", name, [self foo_82]);
   fprintf( FP, "%s: %s\n", name, [self foo_83]);
   fprintf( FP, "%s: %s\n", name, [self foo_84]);
   fprintf( FP, "%s: %s\n", name, [self foo_85]);
   fprintf( FP, "%s: %s\n", name, [self foo_86]);
   fprintf( FP, "%s: %s\n", name, [self foo_87]);
   fprintf( FP, "%s: %s\n", name, [self foo_88]);
   fprintf( FP, "%s: %s\n", name, [self foo_89]);
   fprintf( FP, "%s: %s\n", name, [self foo_90]);
   fprintf( FP, "%s: %s\n", name, [self foo_91]);
   fprintf( FP, "%s: %s\n", name, [self foo_92]);
   fprintf( FP, "%s: %s\n", name, [self foo_93]);
   fprintf( FP, "%s: %s\n", name, [self foo_94]);
   fprintf( FP, "%s: %s\n", name, [self foo_95]);
   fprintf( FP, "%s: %s\n", name, [self foo_96]);
   fprintf( FP, "%s: %s\n", name, [self foo_97]);
   fprintf( FP, "%s: %s\n", name, [self foo_98]);
   fprintf( FP, "%s: %s\n", name, [self foo_99]);
   fprintf( FP, "%s: %s\n", name, [self foo_100]);
   fprintf( FP, "%s: %s\n", name, [self foo_101]);
   fprintf( FP, "%s: %s\n", name, [self foo_102]);
   fprintf( FP, "%s: %s\n", name, [self foo_103]);
   fprintf( FP, "%s: %s\n", name, [self foo_104]);
   fprintf( FP, "%s: %s\n", name, [self foo_105]);
   fprintf( FP, "%s: %s\n", name, [self foo_106]);
   fprintf( FP, "%s: %s\n", name, [self foo_107]);
   fprintf( FP, "%s: %s\n", name, [self foo_108]);
   fprintf( FP, "%s: %s\n", name, [self foo_109]);
   fprintf( FP, "%s: %s\n", name, [self foo_110]);
   fprintf( FP, "%s: %s\n", name, [self foo_111]);
   fprintf( FP, "%s: %s\n", name, [self foo_112]);
   fprintf( FP, "%s: %s\n", name, [self foo_113]);
   fprintf( FP, "%s: %s\n", name, [self foo_114]);
   fprintf( FP, "%s: %s\n", name, [self foo_115]);
   fprintf( FP, "%s: %s\n", name, [self foo_116]);
   fprintf( FP, "%s: %s\n", name, [self foo_117]);
   fprintf( FP, "%s: %s\n", name, [self foo_118]);
   fprintf( FP, "%s: %s\n", name, [self foo_119]);
   fprintf( FP, "%s: %s\n", name, [self foo_120]);
   fprintf( FP, "%s: %s\n", name, [self foo_121]);
   fprintf( FP, "%s: %s\n", name, [self foo_122]);
   fprintf( FP, "%s: %s\n", name, [self foo_123]);
   fprintf( FP, "%s: %s\n", name, [self foo_124]);
   fprintf( FP, "%s: %s\n", name, [self foo_125]);
   fprintf( FP, "%s: %s\n", name, [self foo_126]);
   fprintf( FP, "%s: %s\n", name, [self foo_127]);
   fprintf( FP, "%s: %s\n", name, [self foo_128]);
   fprintf( FP, "%s: %s\n", name, [self foo_129]);
   fprintf( FP, "%s: %s\n", name, [self foo_130]);
   fprintf( FP, "%s: %s\n", name, [self foo_131]);
   fprintf( FP, "%s: %s\n", name, [self foo_132]);
   fprintf( FP, "%s: %s\n", name, [self foo_133]);
   fprintf( FP, "%s: %s\n", name, [self foo_134]);
   fprintf( FP, "%s: %s\n", name, [self foo_135]);
   fprintf( FP, "%s: %s\n", name, [self foo_136]);
   fprintf( FP, "%s: %s\n", name, [self foo_137]);
   fprintf( FP, "%s: %s\n", name, [self foo_138]);
   fprintf( FP, "%s: %s\n", name, [self foo_139]);
   fprintf( FP, "%s: %s\n", name, [self foo_140]);
   fprintf( FP, "%s: %s\n", name, [self foo_141]);
   fprintf( FP, "%s: %s\n", name, [self foo_142]);
   fprintf( FP, "%s: %s\n", name, [self foo_143]);
   fprintf( FP, "%s: %s\n", name, [self foo_144]);
   fprintf( FP, "%s: %s\n", name, [self foo_145]);
   fprintf( FP, "%s: %s\n", name, [self foo_146]);
   fprintf( FP, "%s: %s\n", name, [self foo_147]);
   fprintf( FP, "%s: %s\n", name, [self foo_148]);
   fprintf( FP, "%s: %s\n", name, [self foo_149]);
   fprintf( FP, "%s: %s\n", name, [self foo_150]);
   fprintf( FP, "%s: %s\n", name, [self foo_151]);
   fprintf( FP, "%s: %s\n", name, [self foo_152]);
   fprintf( FP, "%s: %s\n", name, [self foo_153]);
   fprintf( FP, "%s: %s\n", name, [self foo_154]);
   fprintf( FP, "%s: %s\n", name, [self foo_155]);
   fprintf( FP, "%s: %s\n", name, [self foo_156]);
   fprintf( FP, "%s: %s\n", name, [self foo_157]);
   fprintf( FP, "%s: %s\n", name, [self foo_158]);
   fprintf( FP, "%s: %s\n", name, [self foo_159]);
   fprintf( FP, "%s: %s\n", name, [self foo_160]);
   fprintf( FP, "%s: %s\n", name, [self foo_161]);
   fprintf( FP, "%s: %s\n", name, [self foo_162]);
   fprintf( FP, "%s: %s\n", name, [self foo_163]);
   fprintf( FP, "%s: %s\n", name, [self foo_164]);
   fprintf( FP, "%s: %s\n", name, [self foo_165]);
   fprintf( FP, "%s: %s\n", name, [self foo_166]);
   fprintf( FP, "%s: %s\n", name, [self foo_167]);
   fprintf( FP, "%s: %s\n", name, [self foo_168]);
   fprintf( FP, "%s: %s\n", name, [self foo_169]);
   fprintf( FP, "%s: %s\n", name, [self foo_170]);
   fprintf( FP, "%s: %s\n", name, [self foo_171]);
   fprintf( FP, "%s: %s\n", name, [self foo_172]);
   fprintf( FP, "%s: %s\n", name, [self foo_173]);
   fprintf( FP, "%s: %s\n", name, [self foo_174]);
   fprintf( FP, "%s: %s\n", name, [self foo_175]);
   fprintf( FP, "%s: %s\n", name, [self foo_176]);
   fprintf( FP, "%s: %s\n", name, [self foo_177]);
   fprintf( FP, "%s: %s\n", name, [self foo_178]);
   fprintf( FP, "%s: %s\n", name, [self foo_179]);
   fprintf( FP, "%s: %s\n", name, [self foo_180]);
   fprintf( FP, "%s: %s\n", name, [self foo_181]);
   fprintf( FP, "%s: %s\n", name, [self foo_182]);
   fprintf( FP, "%s: %s\n", name, [self foo_183]);
   fprintf( FP, "%s: %s\n", name, [self foo_184]);
   fprintf( FP, "%s: %s\n", name, [self foo_185]);
   fprintf( FP, "%s: %s\n", name, [self foo_186]);
   fprintf( FP, "%s: %s\n", name, [self foo_187]);
   fprintf( FP, "%s: %s\n", name, [self foo_188]);
   fprintf( FP, "%s: %s\n", name, [self foo_189]);
   fprintf( FP, "%s: %s\n", name, [self foo_190]);
   fprintf( FP, "%s: %s\n", name, [self foo_191]);
   fprintf( FP, "%s: %s\n", name, [self foo_192]);
   fprintf( FP, "%s: %s\n", name, [self foo_193]);
   fprintf( FP, "%s: %s\n", name, [self foo_194]);
   fprintf( FP, "%s: %s\n", name, [self foo_195]);
   fprintf( FP, "%s: %s\n", name, [self foo_196]);
   fprintf( FP, "%s: %s\n", name, [self foo_197]);
   fprintf( FP, "%s: %s\n", name, [self foo_198]);
   fprintf( FP, "%s: %s\n", name, [self foo_199]);
   fprintf( FP, "%s: %s\n", name, [self foo_200]);
   fprintf( FP, "%s: %s\n", name, [self foo_201]);
   fprintf( FP, "%s: %s\n", name, [self foo_202]);
   fprintf( FP, "%s: %s\n", name, [self foo_203]);
   fprintf( FP, "%s: %s\n", name, [self foo_204]);
   fprintf( FP, "%s: %s\n", name, [self foo_205]);
   fprintf( FP, "%s: %s\n", name, [self foo_206]);
   fprintf( FP, "%s: %s\n", name, [self foo_207]);
   fprintf( FP, "%s: %s\n", name, [self foo_208]);
   fprintf( FP, "%s: %s\n", name, [self foo_209]);
   fprintf( FP, "%s: %s\n", name, [self foo_210]);
   fprintf( FP, "%s: %s\n", name, [self foo_211]);
   fprintf( FP, "%s: %s\n", name, [self foo_212]);
   fprintf( FP, "%s: %s\n", name, [self foo_213]);
   fprintf( FP, "%s: %s\n", name, [self foo_214]);
   fprintf( FP, "%s: %s\n", name, [self foo_215]);
   fprintf( FP, "%s: %s\n", name, [self foo_216]);
   fprintf( FP, "%s: %s\n", name, [self foo_217]);
   fprintf( FP, "%s: %s\n", name, [self foo_218]);
   fprintf( FP, "%s: %s\n", name, [self foo_219]);
   fprintf( FP, "%s: %s\n", name, [self foo_220]);
   fprintf( FP, "%s: %s\n", name, [self foo_221]);
   fprintf( FP, "%s: %s\n", name, [self foo_222]);
   fprintf( FP, "%s: %s\n", name, [self foo_223]);
   fprintf( FP, "%s: %s\n", name, [self foo_224]);
   fprintf( FP, "%s: %s\n", name, [self foo_225]);
   fprintf( FP, "%s: %s\n", name, [self foo_226]);
   fprintf( FP, "%s: %s\n", name, [self foo_227]);
   fprintf( FP, "%s: %s\n", name, [self foo_228]);
   fprintf( FP, "%s: %s\n", name, [self foo_229]);
   fprintf( FP, "%s: %s\n", name, [self foo_230]);
   fprintf( FP, "%s: %s\n", name, [self foo_231]);
   fprintf( FP, "%s: %s\n", name, [self foo_232]);
   fprintf( FP, "%s: %s\n", name, [self foo_233]);
   fprintf( FP, "%s: %s\n", name, [self foo_234]);
   fprintf( FP, "%s: %s\n", name, [self foo_235]);
   fprintf( FP, "%s: %s\n", name, [self foo_236]);
   fprintf( FP, "%s: %s\n", name, [self foo_237]);
   fprintf( FP, "%s: %s\n", name, [self foo_238]);
   fprintf( FP, "%s: %s\n", name, [self foo_239]);
   fprintf( FP, "%s: %s\n", name, [self foo_240]);
   fprintf( FP, "%s: %s\n", name, [self foo_241]);
   fprintf( FP, "%s: %s\n", name, [self foo_242]);
   fprintf( FP, "%s: %s\n", name, [self foo_243]);
   fprintf( FP, "%s: %s\n", name, [self foo_244]);
   fprintf( FP, "%s: %s\n", name, [self foo_245]);
   fprintf( FP, "%s: %s\n", name, [self foo_246]);
   fprintf( FP, "%s: %s\n", name, [self foo_247]);
   fprintf( FP, "%s: %s\n", name, [self foo_248]);
   fprintf( FP, "%s: %s\n", name, [self foo_249]);
   fprintf( FP, "%s: %s\n", name, [self foo_250]);
   fprintf( FP, "%s: %s\n", name, [self foo_251]);
   fprintf( FP, "%s: %s\n", name, [self foo_252]);
   fprintf( FP, "%s: %s\n", name, [self foo_253]);
   fprintf( FP, "%s: %s\n", name, [self foo_254]);
   fprintf( FP, "%s: %s\n", name, [self foo_255]);
   fprintf( FP, "%s: %s\n", name, [self foo_256]);
   fprintf( FP, "%s: %s\n", name, [self foo_257]);
   fprintf( FP, "%s: %s\n", name, [self foo_258]);
   fprintf( FP, "%s: %s\n", name, [self foo_259]);
   fprintf( FP, "%s: %s\n", name, [self foo_260]);
   fprintf( FP, "%s: %s\n", name, [self foo_261]);
   fprintf( FP, "%s: %s\n", name, [self foo_262]);
   fprintf( FP, "%s: %s\n", name, [self foo_263]);
   fprintf( FP, "%s: %s\n", name, [self foo_264]);
   fprintf( FP, "%s: %s\n", name, [self foo_265]);
   fprintf( FP, "%s: %s\n", name, [self foo_266]);
   fprintf( FP, "%s: %s\n", name, [self foo_267]);
   fprintf( FP, "%s: %s\n", name, [self foo_268]);
   fprintf( FP, "%s: %s\n", name, [self foo_269]);
   fprintf( FP, "%s: %s\n", name, [self foo_270]);
   fprintf( FP, "%s: %s\n", name, [self foo_271]);
   fprintf( FP, "%s: %s\n", name, [self foo_272]);
   fprintf( FP, "%s: %s\n", name, [self foo_273]);
   fprintf( FP, "%s: %s\n", name, [self foo_274]);
   fprintf( FP, "%s: %s\n", name, [self foo_275]);
   fprintf( FP, "%s: %s\n", name, [self foo_276]);
   fprintf( FP, "%s: %s\n", name, [self foo_277]);
   fprintf( FP, "%s: %s\n", name, [self foo_278]);
   fprintf( FP, "%s: %s\n", name, [self foo_279]);
   fprintf( FP, "%s: %s\n", name, [self foo_280]);
   fprintf( FP, "%s: %s\n", name, [self foo_281]);
   fprintf( FP, "%s: %s\n", name, [self foo_282]);
   fprintf( FP, "%s: %s\n", name, [self foo_283]);
   fprintf( FP, "%s: %s\n", name, [self foo_284]);
   fprintf( FP, "%s: %s\n", name, [self foo_285]);
   fprintf( FP, "%s: %s\n", name, [self foo_286]);
   fprintf( FP, "%s: %s\n", name, [self foo_287]);
   fprintf( FP, "%s: %s\n", name, [self foo_288]);
   fprintf( FP, "%s: %s\n", name, [self foo_289]);
   fprintf( FP, "%s: %s\n", name, [self foo_290]);
   fprintf( FP, "%s: %s\n", name, [self foo_291]);
   fprintf( FP, "%s: %s\n", name, [self foo_292]);
   fprintf( FP, "%s: %s\n", name, [self foo_293]);
   fprintf( FP, "%s: %s\n", name, [self foo_294]);
   fprintf( FP, "%s: %s\n", name, [self foo_295]);
   fprintf( FP, "%s: %s\n", name, [self foo_296]);
   fprintf( FP, "%s: %s\n", name, [self foo_297]);
   fprintf( FP, "%s: %s\n", name, [self foo_298]);
   fprintf( FP, "%s: %s\n", name, [self foo_299]);
   fprintf( FP, "%s: %s\n", name, [self foo_300]);
   fprintf( FP, "%s: %s\n", name, [self foo_301]);
   fprintf( FP, "%s: %s\n", name, [self foo_302]);
   fprintf( FP, "%s: %s\n", name, [self foo_303]);
   fprintf( FP, "%s: %s\n", name, [self foo_304]);
   fprintf( FP, "%s: %s\n", name, [self foo_305]);
   fprintf( FP, "%s: %s\n", name, [self foo_306]);
   fprintf( FP, "%s: %s\n", name, [self foo_307]);
   fprintf( FP, "%s: %s\n", name, [self foo_308]);
   fprintf( FP, "%s: %s\n", name, [self foo_309]);
   fprintf( FP, "%s: %s\n", name, [self foo_310]);
   fprintf( FP, "%s: %s\n", name, [self foo_311]);
   fprintf( FP, "%s: %s\n", name, [self foo_312]);
   fprintf( FP, "%s: %s\n", name, [self foo_313]);
   fprintf( FP, "%s: %s\n", name, [self foo_314]);
   fprintf( FP, "%s: %s\n", name, [self foo_315]);
   fprintf( FP, "%s: %s\n", name, [self foo_316]);
   fprintf( FP, "%s: %s\n", name, [self foo_317]);
   fprintf( FP, "%s: %s\n", name, [self foo_318]);
   fprintf( FP, "%s: %s\n", name, [self foo_319]);
   fprintf( FP, "%s: %s\n", name, [self foo_320]);
   fprintf( FP, "%s: %s\n", name, [self foo_321]);
   fprintf( FP, "%s: %s\n", name, [self foo_322]);
   fprintf( FP, "%s: %s\n", name, [self foo_323]);
   fprintf( FP, "%s: %s\n", name, [self foo_324]);
   fprintf( FP, "%s: %s\n", name, [self foo_325]);
   fprintf( FP, "%s: %s\n", name, [self foo_326]);
   fprintf( FP, "%s: %s\n", name, [self foo_327]);
   fprintf( FP, "%s: %s\n", name, [self foo_328]);
   fprintf( FP, "%s: %s\n", name, [self foo_329]);
   fprintf( FP, "%s: %s\n", name, [self foo_330]);
   fprintf( FP, "%s: %s\n", name, [self foo_331]);
   fprintf( FP, "%s: %s\n", name, [self foo_332]);
   fprintf( FP, "%s: %s\n", name, [self foo_333]);
   fprintf( FP, "%s: %s\n", name, [self foo_334]);
   fprintf( FP, "%s: %s\n", name, [self foo_335]);
   fprintf( FP, "%s: %s\n", name, [self foo_336]);
   fprintf( FP, "%s: %s\n", name, [self foo_337]);
   fprintf( FP, "%s: %s\n", name, [self foo_338]);
   fprintf( FP, "%s: %s\n", name, [self foo_339]);
   fprintf( FP, "%s: %s\n", name, [self foo_340]);
   fprintf( FP, "%s: %s\n", name, [self foo_341]);
   fprintf( FP, "%s: %s\n", name, [self foo_342]);
   fprintf( FP, "%s: %s\n", name, [self foo_343]);
   fprintf( FP, "%s: %s\n", name, [self foo_344]);
   fprintf( FP, "%s: %s\n", name, [self foo_345]);
   fprintf( FP, "%s: %s\n", name, [self foo_346]);
   fprintf( FP, "%s: %s\n", name, [self foo_347]);
   fprintf( FP, "%s: %s\n", name, [self foo_348]);
   fprintf( FP, "%s: %s\n", name, [self foo_349]);
   fprintf( FP, "%s: %s\n", name, [self foo_350]);
   fprintf( FP, "%s: %s\n", name, [self foo_351]);
   fprintf( FP, "%s: %s\n", name, [self foo_352]);
   fprintf( FP, "%s: %s\n", name, [self foo_353]);
   fprintf( FP, "%s: %s\n", name, [self foo_354]);
   fprintf( FP, "%s: %s\n", name, [self foo_355]);
   fprintf( FP, "%s: %s\n", name, [self foo_356]);
   fprintf( FP, "%s: %s\n", name, [self foo_357]);
   fprintf( FP, "%s: %s\n", name, [self foo_358]);
   fprintf( FP, "%s: %s\n", name, [self foo_359]);
   fprintf( FP, "%s: %s\n", name, [self foo_360]);
   fprintf( FP, "%s: %s\n", name, [self foo_361]);
   fprintf( FP, "%s: %s\n", name, [self foo_362]);
   fprintf( FP, "%s: %s\n", name, [self foo_363]);
   fprintf( FP, "%s: %s\n", name, [self foo_364]);
   fprintf( FP, "%s: %s\n", name, [self foo_365]);
   fprintf( FP, "%s: %s\n", name, [self foo_366]);
   fprintf( FP, "%s: %s\n", name, [self foo_367]);
   fprintf( FP, "%s: %s\n", name, [self foo_368]);
   fprintf( FP, "%s: %s\n", name, [self foo_369]);
   fprintf( FP, "%s: %s\n", name, [self foo_370]);
   fprintf( FP, "%s: %s\n", name, [self foo_371]);
   fprintf( FP, "%s: %s\n", name, [self foo_372]);
   fprintf( FP, "%s: %s\n", name, [self foo_373]);
   fprintf( FP, "%s: %s\n", name, [self foo_374]);
   fprintf( FP, "%s: %s\n", name, [self foo_375]);
   fprintf( FP, "%s: %s\n", name, [self foo_376]);
   fprintf( FP, "%s: %s\n", name, [self foo_377]);
   fprintf( FP, "%s: %s\n", name, [self foo_378]);
   fprintf( FP, "%s: %s\n", name, [self foo_379]);
   fprintf( FP, "%s: %s\n", name, [self foo_380]);
   fprintf( FP, "%s: %s\n", name, [self foo_381]);
   fprintf( FP, "%s: %s\n", name, [self foo_382]);
   fprintf( FP, "%s: %s\n", name, [self foo_383]);
   fprintf( FP, "%s: %s\n", name, [self foo_384]);
   fprintf( FP, "%s: %s\n", name, [self foo_385]);
   fprintf( FP, "%s: %s\n", name, [self foo_386]);
   fprintf( FP, "%s: %s\n", name, [self foo_387]);
   fprintf( FP, "%s: %s\n", name, [self foo_388]);
   fprintf( FP, "%s: %s\n", name, [self foo_389]);
   fprintf( FP, "%s: %s\n", name, [self foo_390]);
   fprintf( FP, "%s: %s\n", name, [self foo_391]);
   fprintf( FP, "%s: %s\n", name, [self foo_392]);
   fprintf( FP, "%s: %s\n", name, [self foo_393]);
   fprintf( FP, "%s: %s\n", name, [self foo_394]);
   fprintf( FP, "%s: %s\n", name, [self foo_395]);
   fprintf( FP, "%s: %s\n", name, [self foo_396]);
   fprintf( FP, "%s: %s\n", name, [self foo_397]);
   fprintf( FP, "%s: %s\n", name, [self foo_398]);
   fprintf( FP, "%s: %s\n", name, [self foo_399]);
   fprintf( FP, "%s: %s\n", name, [self foo_400]);
   fprintf( FP, "%s: %s\n", name, [self foo_401]);
   fprintf( FP, "%s: %s\n", name, [self foo_402]);
   fprintf( FP, "%s: %s\n", name, [self foo_403]);
   fprintf( FP, "%s: %s\n", name, [self foo_404]);
   fprintf( FP, "%s: %s\n", name, [self foo_405]);
   fprintf( FP, "%s: %s\n", name, [self foo_406]);
   fprintf( FP, "%s: %s\n", name, [self foo_407]);
   fprintf( FP, "%s: %s\n", name, [self foo_408]);
   fprintf( FP, "%s: %s\n", name, [self foo_409]);
   fprintf( FP, "%s: %s\n", name, [self foo_410]);
   fprintf( FP, "%s: %s\n", name, [self foo_411]);
   fprintf( FP, "%s: %s\n", name, [self foo_412]);
   fprintf( FP, "%s: %s\n", name, [self foo_413]);
   fprintf( FP, "%s: %s\n", name, [self foo_414]);
   fprintf( FP, "%s: %s\n", name, [self foo_415]);
   fprintf( FP, "%s: %s\n", name, [self foo_416]);
   fprintf( FP, "%s: %s\n", name, [self foo_417]);
   fprintf( FP, "%s: %s\n", name, [self foo_418]);
   fprintf( FP, "%s: %s\n", name, [self foo_419]);
   fprintf( FP, "%s: %s\n", name, [self foo_420]);
   fprintf( FP, "%s: %s\n", name, [self foo_421]);
   fprintf( FP, "%s: %s\n", name, [self foo_422]);
   fprintf( FP, "%s: %s\n", name, [self foo_423]);
   fprintf( FP, "%s: %s\n", name, [self foo_424]);
   fprintf( FP, "%s: %s\n", name, [self foo_425]);
   fprintf( FP, "%s: %s\n", name, [self foo_426]);
   fprintf( FP, "%s: %s\n", name, [self foo_427]);
   fprintf( FP, "%s: %s\n", name, [self foo_428]);
   fprintf( FP, "%s: %s\n", name, [self foo_429]);
   fprintf( FP, "%s: %s\n", name, [self foo_430]);
   fprintf( FP, "%s: %s\n", name, [self foo_431]);
   fprintf( FP, "%s: %s\n", name, [self foo_432]);
   fprintf( FP, "%s: %s\n", name, [self foo_433]);
   fprintf( FP, "%s: %s\n", name, [self foo_434]);
   fprintf( FP, "%s: %s\n", name, [self foo_435]);
   fprintf( FP, "%s: %s\n", name, [self foo_436]);
   fprintf( FP, "%s: %s\n", name, [self foo_437]);
   fprintf( FP, "%s: %s\n", name, [self foo_438]);
   fprintf( FP, "%s: %s\n", name, [self foo_439]);
   fprintf( FP, "%s: %s\n", name, [self foo_440]);
   fprintf( FP, "%s: %s\n", name, [self foo_441]);
   fprintf( FP, "%s: %s\n", name, [self foo_442]);
   fprintf( FP, "%s: %s\n", name, [self foo_443]);
   fprintf( FP, "%s: %s\n", name, [self foo_444]);
   fprintf( FP, "%s: %s\n", name, [self foo_445]);
   fprintf( FP, "%s: %s\n", name, [self foo_446]);
   fprintf( FP, "%s: %s\n", name, [self foo_447]);
   fprintf( FP, "%s: %s\n", name, [self foo_448]);
   fprintf( FP, "%s: %s\n", name, [self foo_449]);
   fprintf( FP, "%s: %s\n", name, [self foo_450]);
   fprintf( FP, "%s: %s\n", name, [self foo_451]);
   fprintf( FP, "%s: %s\n", name, [self foo_452]);
   fprintf( FP, "%s: %s\n", name, [self foo_453]);
   fprintf( FP, "%s: %s\n", name, [self foo_454]);
   fprintf( FP, "%s: %s\n", name, [self foo_455]);
   fprintf( FP, "%s: %s\n", name, [self foo_456]);
   fprintf( FP, "%s: %s\n", name, [self foo_457]);
   fprintf( FP, "%s: %s\n", name, [self foo_458]);
   fprintf( FP, "%s: %s\n", name, [self foo_459]);
   fprintf( FP, "%s: %s\n", name, [self foo_460]);
   fprintf( FP, "%s: %s\n", name, [self foo_461]);
   fprintf( FP, "%s: %s\n", name, [self foo_462]);
   fprintf( FP, "%s: %s\n", name, [self foo_463]);
   fprintf( FP, "%s: %s\n", name, [self foo_464]);
   fprintf( FP, "%s: %s\n", name, [self foo_465]);
   fprintf( FP, "%s: %s\n", name, [self foo_466]);
   fprintf( FP, "%s: %s\n", name, [self foo_467]);
   fprintf( FP, "%s: %s\n", name, [self foo_468]);
   fprintf( FP, "%s: %s\n", name, [self foo_469]);
   fprintf( FP, "%s: %s\n", name, [self foo_470]);
   fprintf( FP, "%s: %s\n", name, [self foo_471]);
   fprintf( FP, "%s: %s\n", name, [self foo_472]);
   fprintf( FP, "%s: %s\n", name, [self foo_473]);
   fprintf( FP, "%s: %s\n", name, [self foo_474]);
   fprintf( FP, "%s: %s\n", name, [self foo_475]);
   fprintf( FP, "%s: %s\n", name, [self foo_476]);
   fprintf( FP, "%s: %s\n", name, [self foo_477]);
   fprintf( FP, "%s: %s\n", name, [self foo_478]);
   fprintf( FP, "%s: %s\n", name, [self foo_479]);
   fprintf( FP, "%s: %s\n", name, [self foo_480]);
   fprintf( FP, "%s: %s\n", name, [self foo_481]);
   fprintf( FP, "%s: %s\n", name, [self foo_482]);
   fprintf( FP, "%s: %s\n", name, [self foo_483]);
   fprintf( FP, "%s: %s\n", name, [self foo_484]);
   fprintf( FP, "%s: %s\n", name, [self foo_485]);
   fprintf( FP, "%s: %s\n", name, [self foo_486]);
   fprintf( FP, "%s: %s\n", name, [self foo_487]);
   fprintf( FP, "%s: %s\n", name, [self foo_488]);
   fprintf( FP, "%s: %s\n", name, [self foo_489]);
   fprintf( FP, "%s: %s\n", name, [self foo_490]);
   fprintf( FP, "%s: %s\n", name, [self foo_491]);
   fprintf( FP, "%s: %s\n", name, [self foo_492]);
   fprintf( FP, "%s: %s\n", name, [self foo_493]);
   fprintf( FP, "%s: %s\n", name, [self foo_494]);
   fprintf( FP, "%s: %s\n", name, [self foo_495]);
   fprintf( FP, "%s: %s\n", name, [self foo_496]);
   fprintf( FP, "%s: %s\n", name, [self foo_497]);
   fprintf( FP, "%s: %s\n", name, [self foo_498]);
   fprintf( FP, "%s: %s\n", name, [self foo_499]);
   fprintf( FP, "%s: %s\n", name, [self foo_500]);
   fprintf( FP, "%s: %s\n", name, [self foo_501]);
   fprintf( FP, "%s: %s\n", name, [self foo_502]);
   fprintf( FP, "%s: %s\n", name, [self foo_503]);
   fprintf( FP, "%s: %s\n", name, [self foo_504]);
   fprintf( FP, "%s: %s\n", name, [self foo_505]);
   fprintf( FP, "%s: %s\n", name, [self foo_506]);
   fprintf( FP, "%s: %s\n", name, [self foo_507]);
   fprintf( FP, "%s: %s\n", name, [self foo_508]);
   fprintf( FP, "%s: %s\n", name, [self foo_509]);
   fprintf( FP, "%s: %s\n", name, [self foo_510]);
   fprintf( FP, "%s: %s\n", name, [self foo_511]);
   fprintf( FP, "%s: %s\n", name, [self foo_512]);
   fprintf( FP, "%s: %s\n", name, [self foo_513]);
   fprintf( FP, "%s: %s\n", name, [self foo_514]);
   fprintf( FP, "%s: %s\n", name, [self foo_515]);
   fprintf( FP, "%s: %s\n", name, [self foo_516]);
   fprintf( FP, "%s: %s\n", name, [self foo_517]);
   fprintf( FP, "%s: %s\n", name, [self foo_518]);
   fprintf( FP, "%s: %s\n", name, [self foo_519]);
   fprintf( FP, "%s: %s\n", name, [self foo_520]);
   fprintf( FP, "%s: %s\n", name, [self foo_521]);
   fprintf( FP, "%s: %s\n", name, [self foo_522]);
   fprintf( FP, "%s: %s\n", name, [self foo_523]);
   fprintf( FP, "%s: %s\n", name, [self foo_524]);
   fprintf( FP, "%s: %s\n", name, [self foo_525]);
   fprintf( FP, "%s: %s\n", name, [self foo_526]);
   fprintf( FP, "%s: %s\n", name, [self foo_527]);
   fprintf( FP, "%s: %s\n", name, [self foo_528]);
   fprintf( FP, "%s: %s\n", name, [self foo_529]);
   fprintf( FP, "%s: %s\n", name, [self foo_530]);
   fprintf( FP, "%s: %s\n", name, [self foo_531]);
   fprintf( FP, "%s: %s\n", name, [self foo_532]);
   fprintf( FP, "%s: %s\n", name, [self foo_533]);
   fprintf( FP, "%s: %s\n", name, [self foo_534]);
   fprintf( FP, "%s: %s\n", name, [self foo_535]);
   fprintf( FP, "%s: %s\n", name, [self foo_536]);
   fprintf( FP, "%s: %s\n", name, [self foo_537]);
   fprintf( FP, "%s: %s\n", name, [self foo_538]);
   fprintf( FP, "%s: %s\n", name, [self foo_539]);
   fprintf( FP, "%s: %s\n", name, [self foo_540]);
   fprintf( FP, "%s: %s\n", name, [self foo_541]);
   fprintf( FP, "%s: %s\n", name, [self foo_542]);
   fprintf( FP, "%s: %s\n", name, [self foo_543]);
   fprintf( FP, "%s: %s\n", name, [self foo_544]);
   fprintf( FP, "%s: %s\n", name, [self foo_545]);
   fprintf( FP, "%s: %s\n", name, [self foo_546]);
   fprintf( FP, "%s: %s\n", name, [self foo_547]);
   fprintf( FP, "%s: %s\n", name, [self foo_548]);
   fprintf( FP, "%s: %s\n", name, [self foo_549]);
   fprintf( FP, "%s: %s\n", name, [self foo_550]);
   fprintf( FP, "%s: %s\n", name, [self foo_551]);
   fprintf( FP, "%s: %s\n", name, [self foo_552]);
   fprintf( FP, "%s: %s\n", name, [self foo_553]);
   fprintf( FP, "%s: %s\n", name, [self foo_554]);
   fprintf( FP, "%s: %s\n", name, [self foo_555]);
   fprintf( FP, "%s: %s\n", name, [self foo_556]);
   fprintf( FP, "%s: %s\n", name, [self foo_557]);
   fprintf( FP, "%s: %s\n", name, [self foo_558]);
   fprintf( FP, "%s: %s\n", name, [self foo_559]);
   fprintf( FP, "%s: %s\n", name, [self foo_560]);
   fprintf( FP, "%s: %s\n", name, [self foo_561]);
   fprintf( FP, "%s: %s\n", name, [self foo_562]);
   fprintf( FP, "%s: %s\n", name, [self foo_563]);
   fprintf( FP, "%s: %s\n", name, [self foo_564]);
   fprintf( FP, "%s: %s\n", name, [self foo_565]);
   fprintf( FP, "%s: %s\n", name, [self foo_566]);
   fprintf( FP, "%s: %s\n", name, [self foo_567]);
   fprintf( FP, "%s: %s\n", name, [self foo_568]);
   fprintf( FP, "%s: %s\n", name, [self foo_569]);
   fprintf( FP, "%s: %s\n", name, [self foo_570]);
   fprintf( FP, "%s: %s\n", name, [self foo_571]);
   fprintf( FP, "%s: %s\n", name, [self foo_572]);
   fprintf( FP, "%s: %s\n", name, [self foo_573]);
   fprintf( FP, "%s: %s\n", name, [self foo_574]);
   fprintf( FP, "%s: %s\n", name, [self foo_575]);
   fprintf( FP, "%s: %s\n", name, [self foo_576]);
   fprintf( FP, "%s: %s\n", name, [self foo_577]);
   fprintf( FP, "%s: %s\n", name, [self foo_578]);
   fprintf( FP, "%s: %s\n", name, [self foo_579]);
   fprintf( FP, "%s: %s\n", name, [self foo_580]);
   fprintf( FP, "%s: %s\n", name, [self foo_581]);
   fprintf( FP, "%s: %s\n", name, [self foo_582]);
   fprintf( FP, "%s: %s\n", name, [self foo_583]);
   fprintf( FP, "%s: %s\n", name, [self foo_584]);
   fprintf( FP, "%s: %s\n", name, [self foo_585]);
   fprintf( FP, "%s: %s\n", name, [self foo_586]);
   fprintf( FP, "%s: %s\n", name, [self foo_587]);
   fprintf( FP, "%s: %s\n", name, [self foo_588]);
   fprintf( FP, "%s: %s\n", name, [self foo_589]);
   fprintf( FP, "%s: %s\n", name, [self foo_590]);
   fprintf( FP, "%s: %s\n", name, [self foo_591]);
   fprintf( FP, "%s: %s\n", name, [self foo_592]);
   fprintf( FP, "%s: %s\n", name, [self foo_593]);
   fprintf( FP, "%s: %s\n", name, [self foo_594]);
   fprintf( FP, "%s: %s\n", name, [self foo_595]);
   fprintf( FP, "%s: %s\n", name, [self foo_596]);
   fprintf( FP, "%s: %s\n", name, [self foo_597]);
   fprintf( FP, "%s: %s\n", name, [self foo_598]);
   fprintf( FP, "%s: %s\n", name, [self foo_599]);
   fprintf( FP, "%s: %s\n", name, [self foo_600]);
   fprintf( FP, "%s: %s\n", name, [self foo_601]);
   fprintf( FP, "%s: %s\n", name, [self foo_602]);
   fprintf( FP, "%s: %s\n", name, [self foo_603]);
   fprintf( FP, "%s: %s\n", name, [self foo_604]);
   fprintf( FP, "%s: %s\n", name, [self foo_605]);
   fprintf( FP, "%s: %s\n", name, [self foo_606]);
   fprintf( FP, "%s: %s\n", name, [self foo_607]);
   fprintf( FP, "%s: %s\n", name, [self foo_608]);
   fprintf( FP, "%s: %s\n", name, [self foo_609]);
   fprintf( FP, "%s: %s\n", name, [self foo_610]);
   fprintf( FP, "%s: %s\n", name, [self foo_611]);
   fprintf( FP, "%s: %s\n", name, [self foo_612]);
   fprintf( FP, "%s: %s\n", name, [self foo_613]);
   fprintf( FP, "%s: %s\n", name, [self foo_614]);
   fprintf( FP, "%s: %s\n", name, [self foo_615]);
   fprintf( FP, "%s: %s\n", name, [self foo_616]);
   fprintf( FP, "%s: %s\n", name, [self foo_617]);
   fprintf( FP, "%s: %s\n", name, [self foo_618]);
   fprintf( FP, "%s: %s\n", name, [self foo_619]);
   fprintf( FP, "%s: %s\n", name, [self foo_620]);
   fprintf( FP, "%s: %s\n", name, [self foo_621]);
   fprintf( FP, "%s: %s\n", name, [self foo_622]);
   fprintf( FP, "%s: %s\n", name, [self foo_623]);
   fprintf( FP, "%s: %s\n", name, [self foo_624]);
   fprintf( FP, "%s: %s\n", name, [self foo_625]);
   fprintf( FP, "%s: %s\n", name, [self foo_626]);
   fprintf( FP, "%s: %s\n", name, [self foo_627]);
   fprintf( FP, "%s: %s\n", name, [self foo_628]);
   fprintf( FP, "%s: %s\n", name, [self foo_629]);
   fprintf( FP, "%s: %s\n", name, [self foo_630]);
   fprintf( FP, "%s: %s\n", name, [self foo_631]);
   fprintf( FP, "%s: %s\n", name, [self foo_632]);
   fprintf( FP, "%s: %s\n", name, [self foo_633]);
   fprintf( FP, "%s: %s\n", name, [self foo_634]);
   fprintf( FP, "%s: %s\n", name, [self foo_635]);
   fprintf( FP, "%s: %s\n", name, [self foo_636]);
   fprintf( FP, "%s: %s\n", name, [self foo_637]);
   fprintf( FP, "%s: %s\n", name, [self foo_638]);
   fprintf( FP, "%s: %s\n", name, [self foo_639]);
   fprintf( FP, "%s: %s\n", name, [self foo_640]);
   fprintf( FP, "%s: %s\n", name, [self foo_641]);
   fprintf( FP, "%s: %s\n", name, [self foo_642]);
   fprintf( FP, "%s: %s\n", name, [self foo_643]);
   fprintf( FP, "%s: %s\n", name, [self foo_644]);
   fprintf( FP, "%s: %s\n", name, [self foo_645]);
   fprintf( FP, "%s: %s\n", name, [self foo_646]);
   fprintf( FP, "%s: %s\n", name, [self foo_647]);
   fprintf( FP, "%s: %s\n", name, [self foo_648]);
   fprintf( FP, "%s: %s\n", name, [self foo_649]);
   fprintf( FP, "%s: %s\n", name, [self foo_650]);
   fprintf( FP, "%s: %s\n", name, [self foo_651]);
   fprintf( FP, "%s: %s\n", name, [self foo_652]);
   fprintf( FP, "%s: %s\n", name, [self foo_653]);
   fprintf( FP, "%s: %s\n", name, [self foo_654]);
   fprintf( FP, "%s: %s\n", name, [self foo_655]);
   fprintf( FP, "%s: %s\n", name, [self foo_656]);
   fprintf( FP, "%s: %s\n", name, [self foo_657]);
   fprintf( FP, "%s: %s\n", name, [self foo_658]);
   fprintf( FP, "%s: %s\n", name, [self foo_659]);
   fprintf( FP, "%s: %s\n", name, [self foo_660]);
   fprintf( FP, "%s: %s\n", name, [self foo_661]);
   fprintf( FP, "%s: %s\n", name, [self foo_662]);
   fprintf( FP, "%s: %s\n", name, [self foo_663]);
   fprintf( FP, "%s: %s\n", name, [self foo_664]);
   fprintf( FP, "%s: %s\n", name, [self foo_665]);
   fprintf( FP, "%s: %s\n", name, [self foo_666]);
   fprintf( FP, "%s: %s\n", name, [self foo_667]);
   fprintf( FP, "%s: %s\n", name, [self foo_668]);
   fprintf( FP, "%s: %s\n", name, [self foo_669]);
   fprintf( FP, "%s: %s\n", name, [self foo_670]);
   fprintf( FP, "%s: %s\n", name, [self foo_671]);
   fprintf( FP, "%s: %s\n", name, [self foo_672]);
   fprintf( FP, "%s: %s\n", name, [self foo_673]);
   fprintf( FP, "%s: %s\n", name, [self foo_674]);
   fprintf( FP, "%s: %s\n", name, [self foo_675]);
   fprintf( FP, "%s: %s\n", name, [self foo_676]);
   fprintf( FP, "%s: %s\n", name, [self foo_677]);
   fprintf( FP, "%s: %s\n", name, [self foo_678]);
   fprintf( FP, "%s: %s\n", name, [self foo_679]);
   fprintf( FP, "%s: %s\n", name, [self foo_680]);
   fprintf( FP, "%s: %s\n", name, [self foo_681]);
   fprintf( FP, "%s: %s\n", name, [self foo_682]);
   fprintf( FP, "%s: %s\n", name, [self foo_683]);
   fprintf( FP, "%s: %s\n", name, [self foo_684]);
   fprintf( FP, "%s: %s\n", name, [self foo_685]);
   fprintf( FP, "%s: %s\n", name, [self foo_686]);
   fprintf( FP, "%s: %s\n", name, [self foo_687]);
   fprintf( FP, "%s: %s\n", name, [self foo_688]);
   fprintf( FP, "%s: %s\n", name, [self foo_689]);
   fprintf( FP, "%s: %s\n", name, [self foo_690]);
   fprintf( FP, "%s: %s\n", name, [self foo_691]);
   fprintf( FP, "%s: %s\n", name, [self foo_692]);
   fprintf( FP, "%s: %s\n", name, [self foo_693]);
   fprintf( FP, "%s: %s\n", name, [self foo_694]);
   fprintf( FP, "%s: %s\n", name, [self foo_695]);
   fprintf( FP, "%s: %s\n", name, [self foo_696]);
   fprintf( FP, "%s: %s\n", name, [self foo_697]);
   fprintf( FP, "%s: %s\n", name, [self foo_698]);
   fprintf( FP, "%s: %s\n", name, [self foo_699]);
   fprintf( FP, "%s: %s\n", name, [self foo_700]);
   fprintf( FP, "%s: %s\n", name, [self foo_701]);
   fprintf( FP, "%s: %s\n", name, [self foo_702]);
   fprintf( FP, "%s: %s\n", name, [self foo_703]);
   fprintf( FP, "%s: %s\n", name, [self foo_704]);
   fprintf( FP, "%s: %s\n", name, [self foo_705]);
   fprintf( FP, "%s: %s\n", name, [self foo_706]);
   fprintf( FP, "%s: %s\n", name, [self foo_707]);
   fprintf( FP, "%s: %s\n", name, [self foo_708]);
   fprintf( FP, "%s: %s\n", name, [self foo_709]);
   fprintf( FP, "%s: %s\n", name, [self foo_710]);
   fprintf( FP, "%s: %s\n", name, [self foo_711]);
   fprintf( FP, "%s: %s\n", name, [self foo_712]);
   fprintf( FP, "%s: %s\n", name, [self foo_713]);
   fprintf( FP, "%s: %s\n", name, [self foo_714]);
   fprintf( FP, "%s: %s\n", name, [self foo_715]);
   fprintf( FP, "%s: %s\n", name, [self foo_716]);
   fprintf( FP, "%s: %s\n", name, [self foo_717]);
   fprintf( FP, "%s: %s\n", name, [self foo_718]);
   fprintf( FP, "%s: %s\n", name, [self foo_719]);
   fprintf( FP, "%s: %s\n", name, [self foo_720]);
   fprintf( FP, "%s: %s\n", name, [self foo_721]);
   fprintf( FP, "%s: %s\n", name, [self foo_722]);
   fprintf( FP, "%s: %s\n", name, [self foo_723]);
   fprintf( FP, "%s: %s\n", name, [self foo_724]);
   fprintf( FP, "%s: %s\n", name, [self foo_725]);
   fprintf( FP, "%s: %s\n", name, [self foo_726]);
   fprintf( FP, "%s: %s\n", name, [self foo_727]);
   fprintf( FP, "%s: %s\n", name, [self foo_728]);
   fprintf( FP, "%s: %s\n", name, [self foo_729]);
   fprintf( FP, "%s: %s\n", name, [self foo_730]);
   fprintf( FP, "%s: %s\n", name, [self foo_731]);
   fprintf( FP, "%s: %s\n", name, [self foo_732]);
   fprintf( FP, "%s: %s\n", name, [self foo_733]);
   fprintf( FP, "%s: %s\n", name, [self foo_734]);
   fprintf( FP, "%s: %s\n", name, [self foo_735]);
   fprintf( FP, "%s: %s\n", name, [self foo_736]);
   fprintf( FP, "%s: %s\n", name, [self foo_737]);
   fprintf( FP, "%s: %s\n", name, [self foo_738]);
   fprintf( FP, "%s: %s\n", name, [self foo_739]);
   fprintf( FP, "%s: %s\n", name, [self foo_740]);
   fprintf( FP, "%s: %s\n", name, [self foo_741]);
   fprintf( FP, "%s: %s\n", name, [self foo_742]);
   fprintf( FP, "%s: %s\n", name, [self foo_743]);
   fprintf( FP, "%s: %s\n", name, [self foo_744]);
   fprintf( FP, "%s: %s\n", name, [self foo_745]);
   fprintf( FP, "%s: %s\n", name, [self foo_746]);
   fprintf( FP, "%s: %s\n", name, [self foo_747]);
   fprintf( FP, "%s: %s\n", name, [self foo_748]);
   fprintf( FP, "%s: %s\n", name, [self foo_749]);
   fprintf( FP, "%s: %s\n", name, [self foo_750]);
   fprintf( FP, "%s: %s\n", name, [self foo_751]);
   fprintf( FP, "%s: %s\n", name, [self foo_752]);
   fprintf( FP, "%s: %s\n", name, [self foo_753]);
   fprintf( FP, "%s: %s\n", name, [self foo_754]);
   fprintf( FP, "%s: %s\n", name, [self foo_755]);
   fprintf( FP, "%s: %s\n", name, [self foo_756]);
   fprintf( FP, "%s: %s\n", name, [self foo_757]);
   fprintf( FP, "%s: %s\n", name, [self foo_758]);
   fprintf( FP, "%s: %s\n", name, [self foo_759]);
   fprintf( FP, "%s: %s\n", name, [self foo_760]);
   fprintf( FP, "%s: %s\n", name, [self foo_761]);
   fprintf( FP, "%s: %s\n", name, [self foo_762]);
   fprintf( FP, "%s: %s\n", name, [self foo_763]);
   fprintf( FP, "%s: %s\n", name, [self foo_764]);
   fprintf( FP, "%s: %s\n", name, [self foo_765]);
   fprintf( FP, "%s: %s\n", name, [self foo_766]);
   fprintf( FP, "%s: %s\n", name, [self foo_767]);
   fprintf( FP, "%s: %s\n", name, [self foo_768]);
   fprintf( FP, "%s: %s\n", name, [self foo_769]);
   fprintf( FP, "%s: %s\n", name, [self foo_770]);
   fprintf( FP, "%s: %s\n", name, [self foo_771]);
   fprintf( FP, "%s: %s\n", name, [self foo_772]);
   fprintf( FP, "%s: %s\n", name, [self foo_773]);
   fprintf( FP, "%s: %s\n", name, [self foo_774]);
   fprintf( FP, "%s: %s\n", name, [self foo_775]);
   fprintf( FP, "%s: %s\n", name, [self foo_776]);
   fprintf( FP, "%s: %s\n", name, [self foo_777]);
   fprintf( FP, "%s: %s\n", name, [self foo_778]);
   fprintf( FP, "%s: %s\n", name, [self foo_779]);
   fprintf( FP, "%s: %s\n", name, [self foo_780]);
   fprintf( FP, "%s: %s\n", name, [self foo_781]);
   fprintf( FP, "%s: %s\n", name, [self foo_782]);
   fprintf( FP, "%s: %s\n", name, [self foo_783]);
   fprintf( FP, "%s: %s\n", name, [self foo_784]);
   fprintf( FP, "%s: %s\n", name, [self foo_785]);
   fprintf( FP, "%s: %s\n", name, [self foo_786]);
   fprintf( FP, "%s: %s\n", name, [self foo_787]);
   fprintf( FP, "%s: %s\n", name, [self foo_788]);
   fprintf( FP, "%s: %s\n", name, [self foo_789]);
   fprintf( FP, "%s: %s\n", name, [self foo_790]);
   fprintf( FP, "%s: %s\n", name, [self foo_791]);
   fprintf( FP, "%s: %s\n", name, [self foo_792]);
   fprintf( FP, "%s: %s\n", name, [self foo_793]);
   fprintf( FP, "%s: %s\n", name, [self foo_794]);
   fprintf( FP, "%s: %s\n", name, [self foo_795]);
   fprintf( FP, "%s: %s\n", name, [self foo_796]);
   fprintf( FP, "%s: %s\n", name, [self foo_797]);
   fprintf( FP, "%s: %s\n", name, [self foo_798]);
   fprintf( FP, "%s: %s\n", name, [self foo_799]);
   fprintf( FP, "%s: %s\n", name, [self foo_800]);
   fprintf( FP, "%s: %s\n", name, [self foo_801]);
   fprintf( FP, "%s: %s\n", name, [self foo_802]);
   fprintf( FP, "%s: %s\n", name, [self foo_803]);
   fprintf( FP, "%s: %s\n", name, [self foo_804]);
   fprintf( FP, "%s: %s\n", name, [self foo_805]);
   fprintf( FP, "%s: %s\n", name, [self foo_806]);
   fprintf( FP, "%s: %s\n", name, [self foo_807]);
   fprintf( FP, "%s: %s\n", name, [self foo_808]);
   fprintf( FP, "%s: %s\n", name, [self foo_809]);
   fprintf( FP, "%s: %s\n", name, [self foo_810]);
   fprintf( FP, "%s: %s\n", name, [self foo_811]);
   fprintf( FP, "%s: %s\n", name, [self foo_812]);
   fprintf( FP, "%s: %s\n", name, [self foo_813]);
   fprintf( FP, "%s: %s\n", name, [self foo_814]);
   fprintf( FP, "%s: %s\n", name, [self foo_815]);
   fprintf( FP, "%s: %s\n", name, [self foo_816]);
   fprintf( FP, "%s: %s\n", name, [self foo_817]);
   fprintf( FP, "%s: %s\n", name, [self foo_818]);
   fprintf( FP, "%s: %s\n", name, [self foo_819]);
   fprintf( FP, "%s: %s\n", name, [self foo_820]);
   fprintf( FP, "%s: %s\n", name, [self foo_821]);
   fprintf( FP, "%s: %s\n", name, [self foo_822]);
   fprintf( FP, "%s: %s\n", name, [self foo_823]);
   fprintf( FP, "%s: %s\n", name, [self foo_824]);
   fprintf( FP, "%s: %s\n", name, [self foo_825]);
   fprintf( FP, "%s: %s\n", name, [self foo_826]);
   fprintf( FP, "%s: %s\n", name, [self foo_827]);
   fprintf( FP, "%s: %s\n", name, [self foo_828]);
   fprintf( FP, "%s: %s\n", name, [self foo_829]);
   fprintf( FP, "%s: %s\n", name, [self foo_830]);
   fprintf( FP, "%s: %s\n", name, [self foo_831]);
   fprintf( FP, "%s: %s\n", name, [self foo_832]);
   fprintf( FP, "%s: %s\n", name, [self foo_833]);
   fprintf( FP, "%s: %s\n", name, [self foo_834]);
   fprintf( FP, "%s: %s\n", name, [self foo_835]);
   fprintf( FP, "%s: %s\n", name, [self foo_836]);
   fprintf( FP, "%s: %s\n", name, [self foo_837]);
   fprintf( FP, "%s: %s\n", name, [self foo_838]);
   fprintf( FP, "%s: %s\n", name, [self foo_839]);
   fprintf( FP, "%s: %s\n", name, [self foo_840]);
   fprintf( FP, "%s: %s\n", name, [self foo_841]);
   fprintf( FP, "%s: %s\n", name, [self foo_842]);
   fprintf( FP, "%s: %s\n", name, [self foo_843]);
   fprintf( FP, "%s: %s\n", name, [self foo_844]);
   fprintf( FP, "%s: %s\n", name, [self foo_845]);
   fprintf( FP, "%s: %s\n", name, [self foo_846]);
   fprintf( FP, "%s: %s\n", name, [self foo_847]);
   fprintf( FP, "%s: %s\n", name, [self foo_848]);
   fprintf( FP, "%s: %s\n", name, [self foo_849]);
   fprintf( FP, "%s: %s\n", name, [self foo_850]);
   fprintf( FP, "%s: %s\n", name, [self foo_851]);
   fprintf( FP, "%s: %s\n", name, [self foo_852]);
   fprintf( FP, "%s: %s\n", name, [self foo_853]);
   fprintf( FP, "%s: %s\n", name, [self foo_854]);
   fprintf( FP, "%s: %s\n", name, [self foo_855]);
   fprintf( FP, "%s: %s\n", name, [self foo_856]);
   fprintf( FP, "%s: %s\n", name, [self foo_857]);
   fprintf( FP, "%s: %s\n", name, [self foo_858]);
   fprintf( FP, "%s: %s\n", name, [self foo_859]);
   fprintf( FP, "%s: %s\n", name, [self foo_860]);
   fprintf( FP, "%s: %s\n", name, [self foo_861]);
   fprintf( FP, "%s: %s\n", name, [self foo_862]);
   fprintf( FP, "%s: %s\n", name, [self foo_863]);
   fprintf( FP, "%s: %s\n", name, [self foo_864]);
   fprintf( FP, "%s: %s\n", name, [self foo_865]);
   fprintf( FP, "%s: %s\n", name, [self foo_866]);
   fprintf( FP, "%s: %s\n", name, [self foo_867]);
   fprintf( FP, "%s: %s\n", name, [self foo_868]);
   fprintf( FP, "%s: %s\n", name, [self foo_869]);
   fprintf( FP, "%s: %s\n", name, [self foo_870]);
   fprintf( FP, "%s: %s\n", name, [self foo_871]);
   fprintf( FP, "%s: %s\n", name, [self foo_872]);
   fprintf( FP, "%s: %s\n", name, [self foo_873]);
   fprintf( FP, "%s: %s\n", name, [self foo_874]);
   fprintf( FP, "%s: %s\n", name, [self foo_875]);
   fprintf( FP, "%s: %s\n", name, [self foo_876]);
   fprintf( FP, "%s: %s\n", name, [self foo_877]);
   fprintf( FP, "%s: %s\n", name, [self foo_878]);
   fprintf( FP, "%s: %s\n", name, [self foo_879]);
   fprintf( FP, "%s: %s\n", name, [self foo_880]);
   fprintf( FP, "%s: %s\n", name, [self foo_881]);
   fprintf( FP, "%s: %s\n", name, [self foo_882]);
   fprintf( FP, "%s: %s\n", name, [self foo_883]);
   fprintf( FP, "%s: %s\n", name, [self foo_884]);
   fprintf( FP, "%s: %s\n", name, [self foo_885]);
   fprintf( FP, "%s: %s\n", name, [self foo_886]);
   fprintf( FP, "%s: %s\n", name, [self foo_887]);
   fprintf( FP, "%s: %s\n", name, [self foo_888]);
   fprintf( FP, "%s: %s\n", name, [self foo_889]);
   fprintf( FP, "%s: %s\n", name, [self foo_890]);
   fprintf( FP, "%s: %s\n", name, [self foo_891]);
   fprintf( FP, "%s: %s\n", name, [self foo_892]);
   fprintf( FP, "%s: %s\n", name, [self foo_893]);
   fprintf( FP, "%s: %s\n", name, [self foo_894]);
   fprintf( FP, "%s: %s\n", name, [self foo_895]);
   fprintf( FP, "%s: %s\n", name, [self foo_896]);
   fprintf( FP, "%s: %s\n", name, [self foo_897]);
   fprintf( FP, "%s: %s\n", name, [self foo_898]);
   fprintf( FP, "%s: %s\n", name, [self foo_899]);
   fprintf( FP, "%s: %s\n", name, [self foo_900]);
   fprintf( FP, "%s: %s\n", name, [self foo_901]);
   fprintf( FP, "%s: %s\n", name, [self foo_902]);
   fprintf( FP, "%s: %s\n", name, [self foo_903]);
   fprintf( FP, "%s: %s\n", name, [self foo_904]);
   fprintf( FP, "%s: %s\n", name, [self foo_905]);
   fprintf( FP, "%s: %s\n", name, [self foo_906]);
   fprintf( FP, "%s: %s\n", name, [self foo_907]);
   fprintf( FP, "%s: %s\n", name, [self foo_908]);
   fprintf( FP, "%s: %s\n", name, [self foo_909]);
   fprintf( FP, "%s: %s\n", name, [self foo_910]);
   fprintf( FP, "%s: %s\n", name, [self foo_911]);
   fprintf( FP, "%s: %s\n", name, [self foo_912]);
   fprintf( FP, "%s: %s\n", name, [self foo_913]);
   fprintf( FP, "%s: %s\n", name, [self foo_914]);
   fprintf( FP, "%s: %s\n", name, [self foo_915]);
   fprintf( FP, "%s: %s\n", name, [self foo_916]);
   fprintf( FP, "%s: %s\n", name, [self foo_917]);
   fprintf( FP, "%s: %s\n", name, [self foo_918]);
   fprintf( FP, "%s: %s\n", name, [self foo_919]);
   fprintf( FP, "%s: %s\n", name, [self foo_920]);
   fprintf( FP, "%s: %s\n", name, [self foo_921]);
   fprintf( FP, "%s: %s\n", name, [self foo_922]);
   fprintf( FP, "%s: %s\n", name, [self foo_923]);
   fprintf( FP, "%s: %s\n", name, [self foo_924]);
   fprintf( FP, "%s: %s\n", name, [self foo_925]);
   fprintf( FP, "%s: %s\n", name, [self foo_926]);
   fprintf( FP, "%s: %s\n", name, [self foo_927]);
   fprintf( FP, "%s: %s\n", name, [self foo_928]);
   fprintf( FP, "%s: %s\n", name, [self foo_929]);
   fprintf( FP, "%s: %s\n", name, [self foo_930]);
   fprintf( FP, "%s: %s\n", name, [self foo_931]);
   fprintf( FP, "%s: %s\n", name, [self foo_932]);
   fprintf( FP, "%s: %s\n", name, [self foo_933]);
   fprintf( FP, "%s: %s\n", name, [self foo_934]);
   fprintf( FP, "%s: %s\n", name, [self foo_935]);
   fprintf( FP, "%s: %s\n", name, [self foo_936]);
   fprintf( FP, "%s: %s\n", name, [self foo_937]);
   fprintf( FP, "%s: %s\n", name, [self foo_938]);
   fprintf( FP, "%s: %s\n", name, [self foo_939]);
   fprintf( FP, "%s: %s\n", name, [self foo_940]);
   fprintf( FP, "%s: %s\n", name, [self foo_941]);
   fprintf( FP, "%s: %s\n", name, [self foo_942]);
   fprintf( FP, "%s: %s\n", name, [self foo_943]);
   fprintf( FP, "%s: %s\n", name, [self foo_944]);
   fprintf( FP, "%s: %s\n", name, [self foo_945]);
   fprintf( FP, "%s: %s\n", name, [self foo_946]);
   fprintf( FP, "%s: %s\n", name, [self foo_947]);
   fprintf( FP, "%s: %s\n", name, [self foo_948]);
   fprintf( FP, "%s: %s\n", name, [self foo_949]);
   fprintf( FP, "%s: %s\n", name, [self foo_950]);
   fprintf( FP, "%s: %s\n", name, [self foo_951]);
   fprintf( FP, "%s: %s\n", name, [self foo_952]);
   fprintf( FP, "%s: %s\n", name, [self foo_953]);
   fprintf( FP, "%s: %s\n", name, [self foo_954]);
   fprintf( FP, "%s: %s\n", name, [self foo_955]);
   fprintf( FP, "%s: %s\n", name, [self foo_956]);
   fprintf( FP, "%s: %s\n", name, [self foo_957]);
   fprintf( FP, "%s: %s\n", name, [self foo_958]);
   fprintf( FP, "%s: %s\n", name, [self foo_959]);
   fprintf( FP, "%s: %s\n", name, [self foo_960]);
   fprintf( FP, "%s: %s\n", name, [self foo_961]);
   fprintf( FP, "%s: %s\n", name, [self foo_962]);
   fprintf( FP, "%s: %s\n", name, [self foo_963]);
   fprintf( FP, "%s: %s\n", name, [self foo_964]);
   fprintf( FP, "%s: %s\n", name, [self foo_965]);
   fprintf( FP, "%s: %s\n", name, [self foo_966]);
   fprintf( FP, "%s: %s\n", name, [self foo_967]);
   fprintf( FP, "%s: %s\n", name, [self foo_968]);
   fprintf( FP, "%s: %s\n", name, [self foo_969]);
   fprintf( FP, "%s: %s\n", name, [self foo_970]);
   fprintf( FP, "%s: %s\n", name, [self foo_971]);
   fprintf( FP, "%s: %s\n", name, [self foo_972]);
   fprintf( FP, "%s: %s\n", name, [self foo_973]);
   fprintf( FP, "%s: %s\n", name, [self foo_974]);
   fprintf( FP, "%s: %s\n", name, [self foo_975]);
   fprintf( FP, "%s: %s\n", name, [self foo_976]);
   fprintf( FP, "%s: %s\n", name, [self foo_977]);
   fprintf( FP, "%s: %s\n", name, [self foo_978]);
   fprintf( FP, "%s: %s\n", name, [self foo_979]);
   fprintf( FP, "%s: %s\n", name, [self foo_980]);
   fprintf( FP, "%s: %s\n", name, [self foo_981]);
   fprintf( FP, "%s: %s\n", name, [self foo_982]);
   fprintf( FP, "%s: %s\n", name, [self foo_983]);
   fprintf( FP, "%s: %s\n", name, [self foo_984]);
   fprintf( FP, "%s: %s\n", name, [self foo_985]);
   fprintf( FP, "%s: %s\n", name, [self foo_986]);
   fprintf( FP, "%s: %s\n", name, [self foo_987]);
   fprintf( FP, "%s: %s\n", name, [self foo_988]);
   fprintf( FP, "%s: %s\n", name, [self foo_989]);
   fprintf( FP, "%s: %s\n", name, [self foo_990]);
   fprintf( FP, "%s: %s\n", name, [self foo_991]);
   fprintf( FP, "%s: %s\n", name, [self foo_992]);
   fprintf( FP, "%s: %s\n", name, [self foo_993]);
   fprintf( FP, "%s: %s\n", name, [self foo_994]);
   fprintf( FP, "%s: %s\n", name, [self foo_995]);
   fprintf( FP, "%s: %s\n", name, [self foo_996]);
   fprintf( FP, "%s: %s\n", name, [self foo_997]);
   fprintf( FP, "%s: %s\n", name, [self foo_998]);
   fprintf( FP, "%s: %s\n", name, [self foo_999]);
   fprintf( FP, "%s: %s\n", name, [self foo_1000]);
   fprintf( FP, "%s: %s\n", name, [self foo_1001]);
   fprintf( FP, "%s: %s\n", name, [self foo_1002]);
   fprintf( FP, "%s: %s\n", name, [self foo_1003]);
   fprintf( FP, "%s: %s\n", name, [self foo_1004]);
   fprintf( FP, "%s: %s\n", name, [self foo_1005]);
   fprintf( FP, "%s: %s\n", name, [self foo_1006]);
   fprintf( FP, "%s: %s\n", name, [self foo_1007]);
   fprintf( FP, "%s: %s\n", name, [self foo_1008]);
   fprintf( FP, "%s: %s\n", name, [self foo_1009]);
   fprintf( FP, "%s: %s\n", name, [self foo_1010]);
   fprintf( FP, "%s: %s\n", name, [self foo_1011]);
   fprintf( FP, "%s: %s\n", name, [self foo_1012]);
   fprintf( FP, "%s: %s\n", name, [self foo_1013]);
   fprintf( FP, "%s: %s\n", name, [self foo_1014]);
   fprintf( FP, "%s: %s\n", name, [self foo_1015]);
   fprintf( FP, "%s: %s\n", name, [self foo_1016]);
   fprintf( FP, "%s: %s\n", name, [self foo_1017]);
   fprintf( FP, "%s: %s\n", name, [self foo_1018]);
   fprintf( FP, "%s: %s\n", name, [self foo_1019]);
   fprintf( FP, "%s: %s\n", name, [self foo_1020]);
   fprintf( FP, "%s: %s\n", name, [self foo_1021]);
   fprintf( FP, "%s: %s\n", name, [self foo_1022]);
   fprintf( FP, "%s: %s\n", name, [self foo_1023]);
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