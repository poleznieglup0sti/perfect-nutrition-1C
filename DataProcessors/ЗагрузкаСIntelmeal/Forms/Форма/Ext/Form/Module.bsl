﻿&НаКлиенте
Перем АдресСервера;  

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Страница = "http://www.intelmeal.ru/nutrition/foodinfo-acidophilus-1,0-proc-fat-ru.php";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	АдресСервера = "www.intelmeal.ru";
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПродуктыПоКатегории(Команда)
	
	ЗапросHTTP 						= Новый HTTPСоединение(АдресСервера);   	  
	ИмяФайла 						= ПолучитьИмяВременногоФайла();
	Каталог 						= СтрЗаменить(СтрЗаменить(Объект.Страница, "http://", ""), АдресСервера, "");
	ЧтениеХТМЛ 						= Новый ЧтениеHTML; 
	ПостроительДОМ 					= Новый ПостроительDOM; 
	Флаг 							= Ложь; 
	Наименование					= "";
		
	ЗапросHTTP.Получить(Каталог, ИмяФайла); 
	
	ЧтениеХТМЛ.ОткрытьФайл(ИмяФайла, "windows-1251"); 
	
	ДокументХТМЛ	= ПостроительДОМ.Прочитать(ЧтениеХТМЛ); 	
	ЭлементыTABLE	= ДокументХТМЛ.ПолучитьЭлементыПоИмени("TABLE"); 
	Для каждого ЭлементTABLE Из ЭлементыTABLE Цикл
		
		Если ЭлементTABLE.ИмяКласса = "" Тогда  			
		 
			ЭлементыА = ЭлементTABLE.ПолучитьЭлементыПоИмени("A");
			
			Для Каждого ЭлементА из ЭлементыА Цикл 		
				ПолучитьДанныеСоСтраницы(ЭлементА.Гиперссылка); 		
			КонецЦикла;
		
		КонецЕсли;
		
	КонецЦикла; 
	 	
		
	ЧтениеХТМЛ.Закрыть();
	
	НачатьУдалениеФайлов(Новый ОписаниеОповещения("УдалениеВременногоФайлаЗавершение", ЭтотОбъект), ИмяФайла);
	
КонецПроцедуры  

&НаКлиенте
Процедура ПолучитьДанные(Команда) 	      
	
	ПолучитьДанныеСоСтраницы(Объект.Страница);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	ЗагрузитьДанныеНаСервере();
КонецПроцедуры   

&НаКлиенте
Процедура ПолучитьДанныеСоСтраницы(ТекСтраница)
	
	ЗапросHTTP 		= Новый HTTPСоединение(АдресСервера);
	ИмяФайла 		= ПолучитьИмяВременногоФайла();
	Каталог 		= СтрЗаменить(СтрЗаменить(ТекСтраница, "http://", ""), АдресСервера, "");
	ЧтениеХТМЛ 		= Новый ЧтениеHTML; 
	ПостроительДОМ 	= Новый ПостроительDOM; 
	Флаг 			= Ложь; 
	Наименование	= "";
	
	Попытка
		Ответ = ЗапросHTTP.Получить(Каталог, ИмяФайла);	
	Исключение
	   Сообщение = Новый СообщениеПользователю;
	   Сообщение.Текст = ОписаниеОшибки();
	   Сообщение.Сообщить(); 
	   Возврат;
   КонецПопытки; 
	 
	
	ЧтениеХТМЛ.ОткрытьФайл(ИмяФайла, "windows-1251"); 
	
	ДокументХТМЛ	= ПостроительДОМ.Прочитать(ЧтениеХТМЛ); 	
	ЭлементыDIV		= ДокументХТМЛ.ПолучитьЭлементыПоИмени("DIV"); 	
	ЭлементыН1 		= ДокументХТМЛ.ПолучитьЭлементыПоИмени("H1");
	
	Для Каждого ЭлементН1 из ЭлементыН1 Цикл 		
		
		Если ЭлементН1.ИмяКласса = "raspberry" ИЛИ ЭлементН1.ТекстовоеСодержимое = "Пищевая ценность, химический состав и калорийность" Тогда  			
			
			ЭлементыРодителя = ЭлементН1.РодительскийУзел.ДочерниеУзлы;
			Для каждого Ит Из ЭлементыРодителя Цикл     	
				
				Если ТипЗнч(Ит) = Тип("ЭлементHTML") Тогда
					
					Если Ит <> ЭлементН1 Тогда
						Наименование = Ит.ТекстовоеСодержимое;
						Флаг = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЕсли;				  
				
			КонецЦикла; 			 
			
		КонецЕсли;
		
		Если Флаг Тогда
			Прервать;	
		КонецЕсли; 
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Наименование) Тогда  		
	 
		НоваяСтрока 				= Объект.СписокСтраниц.Добавить();
		НоваяСтрока.АдресURL 		= ТекСтраница;
		НоваяСтрока.Наименование 	= Наименование;
		
		Для Каждого ЭлементDIV из ЭлементыDIV Цикл 		
			
			Если ЭлементDIV.ИмяКласса = "fd0" Тогда  				
				
				Калорийность = ПолучитьДанныеБлока(Наименование, ЭлементDIV);  				
				
				Если ЗначениеЗаполнено(Калорийность) Тогда
					НоваяСтрока.Калорийность = Калорийность;	
				КонецЕсли;
				
			КонецЕсли;			 
			
		КонецЦикла; 		
	
	КонецЕсли;
	
	ЧтениеХТМЛ.Закрыть();
	
	НачатьУдалениеФайлов(Новый ОписаниеОповещения("УдалениеВременногоФайлаЗавершение", ЭтотОбъект, Новый Структура("Наименование, НомерСтроки", Наименование, НоваяСтрока.НомерСтроки)), ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалениеВременногоФайлаЗавершение(ДополнительныеПараметры) Экспорт
	
	//Если ЗначениеЗаполнено(ДополнительныеПараметры.Наименование) Тогда 		
	// 
	//	Сообщение = Новый СообщениеПользователю;
	//	Сообщение.Текст = "Получены данные по продукту " + ДополнительныеПараметры.Наименование;
	//	Сообщение.Поле = "СписокСтраниц[" + (ДополнительныеПараметры.НомерСтроки - 1) + "].Цена";
	//	Сообщение.ПутьКДанным = "Объект"; 
	//	Сообщение.Сообщить(); 	
	//
	//КонецЕсли;

КонецПроцедуры   

&НаКлиенте 
Функция ПолучитьДанныеБлока(Наименование, ЭлементФД0)
	
	Результат 		= 0;
	ТипНутриента 	= ПредопределенноеЗначение("Перечисление.ТипыНутриентов.ПустаяСсылка");  	
	ЭлементПД 		= ЭлементФД0.ПервыйДочерний;
	
	Если ЭлементПД.ИмяКласса = "_h1" Тогда
		
		Текст = ВРег(ЭлементПД.ТекстовоеСодержимое);
		Если Текст = ВРег("Аминокислотный скор") Тогда
			ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Аминокислоты");	
		ИначеЕсли Текст = ВРег("СООТНОШЕНИЕ ВРЕДНЫХ (НЖК) И  ПОЛЕЗНЫХ (ПНЖК И МНЖК) ЖИРОВ") Тогда 
			ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Жиры");
		ИначеЕсли Текст = ВРег("Углеводы") Тогда 
			ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Углеводы");
		ИначеЕсли Текст = ВРег("Витамины") Тогда 
			ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Витамины");
		ИначеЕсли Текст = ВРег("Минераллы") Тогда 
			ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Минералы");
		ИначеЕсли Текст = ВРег("Диаграмма состава продукта по весу") Тогда
			ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Прочее");
		ИначеЕсли Текст = ВРег("БЕЛКИ: ЖИРЫ : УГЛЕВОДЫ : СПИРТ  ПО КАЛОРИЙНОСТИ") Тогда
			
			ДочерниеDIV = ЭлементФД0.ПолучитьЭлементыПоИмени("DIV");	
			Для каждого Ит Из ДочерниеDIV Цикл				
				Если Ит.ИмяКласса = "raspberry fd4 _h2" Тогда
					
					МассивЧисел = омРаботаСПростымиТипами.ПолучитьВсеЧислаВСтроке(Ит.ТекстовоеСодержимое);
					Если МассивЧисел.Количество() > 0 Тогда
						Результат =	МассивЧисел[0];
					КонецЕсли;
					
				КонецЕсли; 	
			КонецЦикла;		
			
		КонецЕсли;
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ТипНутриента) Тогда
		
		ДочерниеDIV = ЭлементФД0.ПолучитьЭлементыПоИмени("DIV");	
		Для каждого Ит Из ДочерниеDIV Цикл
			
			Если ТипЗнч(Ит) = Тип("ТекстDOM") Тогда
				Продолжить;	
			КонецЕсли; 
			
			АтрибутCNT = Ит.Атрибуты.ПолучитьИменованныйЭлемент("cnt");
			Если АтрибутCNT <> Неопределено  Тогда
				Если АтрибутCNT.Значение = "0" Тогда
					
					ДанныеСтроки = Новый Структура("Наименование, ТипНутриента, Нутриент, Количество", Наименование, ТипНутриента);		
					
					СписокНутриентов = Ит.ДочерниеУзлы;
					Для каждого Сч Из СписокНутриентов Цикл
						Значение = СокрЛП(Сч.ТекстовоеСодержимое);
						Если Сч.ИмяКласса = "fd1" Тогда
							ДанныеСтроки.Нутриент = Значение;
						ИначеЕсли Сч.ИмяКласса = "fd4" Тогда 
							ДанныеСтроки.Количество = ?(Значение = "~", "", Значение);
						КонецЕсли; 
					КонецЦикла;
					
					Если ЗначениеЗаполнено(ДанныеСтроки.Нутриент) И ЗначениеЗаполнено(ДанныеСтроки.Количество) Тогда
						ЗаполнитьЗначенияСвойств(Объект.ХимСостав.Добавить(), ДанныеСтроки); 					
					КонецЕсли; 
					
				ИначеЕсли АтрибутCNT.Значение = "1" Тогда 
					
					ДанныеСтроки = Новый Структура("Наименование, ТипНутриента, Нутриент, Количество", Наименование, ТипНутриента);		
					
					СписокНутриентов = Ит.ДочерниеУзлы;
					Для каждого Сч Из СписокНутриентов Цикл
						
						Если ТипЗнч(Сч) = Тип("ТекстDOM") Тогда
							Продолжить;	
						КонецЕсли;
						
						Значение = СокрЛП(Сч.ТекстовоеСодержимое);
						Если Найти(Сч.ИмяКласса, "_h2") > 0 Тогда
							Если Найти(Сч.ИмяКласса, "fd1") > 0 Тогда
								ДанныеСтроки.Нутриент = Значение;
							ИначеЕсли  Найти(Сч.ИмяКласса, "fd4") > 0 Тогда 
								ДанныеСтроки.Количество = ?(Значение = "~", "", Значение);
							КонецЕсли;	
						КонецЕсли; 
						 
					КонецЦикла;
					
					Если ЗначениеЗаполнено(ДанныеСтроки.Нутриент) И ЗначениеЗаполнено(ДанныеСтроки.Количество) Тогда
						ЗаполнитьЗначенияСвойств(Объект.ХимСоставОбщиеПоказатели.Добавить(), ДанныеСтроки); 					
					КонецЕсли;
					
				КонецЕсли; 	
			КонецЕсли; 
			
		КонецЦикла; 
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции  

&НаСервере
Процедура ЗагрузитьДанныеНаСервере()
		
	Для каждого СтрокаСписка Из Объект.СписокСтраниц Цикл
		
		Если ЗначениеЗаполнено(СтрокаСписка.Наименование) Тогда			
			
			ЭтоНовыйПродукт			= Ложь; 			 			
			НаименованиеПродукта 	= СтрокаСписка.Наименование; 			
			ДанныеЗаполнения 		= Новый Структура("Родитель, Калорийность, Белки, Жиры, Углеводы", Объект.Родитель, СтрокаСписка.Калорийность);
			
			МассивСтрокНутриентов 		= Объект.ХимСостав.НайтиСтроки(Новый Структура("Наименование", НаименованиеПродукта));  	
			МассивСтрокОбщихПоказателей = Объект.ХимСоставОбщиеПоказатели.НайтиСтроки(Новый Структура("Наименование", НаименованиеПродукта));
						
			Продукт = ПолучитьПродуктПоНаименованию(ТРег(НаименованиеПродукта), Справочники.ИсточникиИнформации.INTELMEAL, ЭтоНовыйПродукт);
			
			НаборЗаписей = РегистрыСведений.ХимическийСоставПродуктов.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Продукт.Установить(Продукт);
			
			Запись 					= НаборЗаписей.Добавить();
			Запись.Продукт 			= Продукт;
			Запись.Нутриент			= Справочники.Нутриенты.Калорийность; 						
			Запись.Количество 		= СтрокаСписка.Калорийность; 		
			
			Запись 					= НаборЗаписей.Добавить();
			Запись.Продукт 			= Продукт;
			Запись.Нутриент			= Справочники.Нутриенты.Белки; 						
			Запись.Количество 		= СтрокаСписка.Белки;
			
			Запись 					= НаборЗаписей.Добавить();
			Запись.Продукт 			= Продукт;
			Запись.Нутриент			= Справочники.Нутриенты.Жиры; 						
			Запись.Количество 		= СтрокаСписка.Жиры;
			
			Запись 					= НаборЗаписей.Добавить();
			Запись.Продукт 			= Продукт;
			Запись.Нутриент			= Справочники.Нутриенты.Углеводы; 						
			Запись.Количество 		= СтрокаСписка.Углеводы;
			
			Для каждого СтрокаНутриентов Из МассивСтрокНутриентов Цикл  				
				
				НаименованиеНутриента 	= СтрокаНутриентов.Нутриент;
				ТипНутриента			= СтрокаНутриентов.ТипНутриента;
				Показатель				= СтрокаНутриентов.Количество;
				
				Если ЗначениеЗаполнено(НаименованиеНутриента) Тогда  					 
					
					Нутриент 			= Справочники.Нутриенты.ПустаяСсылка();
					Количество 			= 0;
					МинКоличество 		= 0;
					МаксКоличество 		= 0;
					Делитель    		= 1;
					Точность			= 0;
					ИмяОбщегоПоказтеля	= "";
					
					Если ТипНутриента = Перечисления.ТипыНутриентов.Витамины Тогда
						
						Точность = 0.2;											 
						
						//Если СтрокаНутриентов.Нутриент = "Витамин А, РЭ" Тогда
						//	Нутриент = Справочники.Нутриенты.ВитаминA;	
						//ИначеЕсли СтрокаНутриентов.Нутриент = "Витамин A, МЕ" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминA;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "альфа Каротин" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминA;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "бета Каротин" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминA;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "бета Криптоксантин" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминA;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "Ликопин" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминA;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "Лютеин + Зеаксантин" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминA;	
						//	
						//ИначеЕсли СтрокаНутриентов.Нутриент = "Витамин D D2 + D3" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминD;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "Витамин D2 эргокальциферол" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминD;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "Витамин D3 холекальциферол" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминD;

						//ИначеЕсли СтрокаНутриентов.Нутриент = "бета Токоферол" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминE;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "гамма Токоферол" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминE;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "дельта Токоферол" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминE;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "Витамин E, добавленный" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминE;   
						//	
						//ИначеЕсли СтрокаНутриентов.Нутриент = "Менахинон-4 (МК4)" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминK;
						//ИначеЕсли СтрокаНутриентов.Нутриент = "Дигидрофиллохинон" Тогда 	
						//	Нутриент = Справочники.Нутриенты.ВитаминK;
							
						Если НаименованиеНутриента = "Витамин C" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминC;  							
												
						ИначеЕсли НаименованиеНутриента = "Витамин B1, Тиамин" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB1;
						ИначеЕсли НаименованиеНутриента = "Витамин B2, Рибофлавин" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB2;
						ИначеЕсли НаименованиеНутриента = "Витамин B5, Пантотеновая кислота" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB5;
						ИначеЕсли НаименованиеНутриента = "Витамин B6, Пиридоксин" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB6;
						ИначеЕсли НаименованиеНутриента = "Витамин B9, Фолаты" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB9;
						ИначеЕсли НаименованиеНутриента = "Фолаты природные" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB9;
						ИначеЕсли НаименованиеНутриента = "Фолиевая кислота" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB9;
						ИначеЕсли НаименованиеНутриента = "Фолаты ДЭФ" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB9;							
						ИначеЕсли НаименованиеНутриента = "Витамин B12, Кобаламин" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB12;
						ИначеЕсли НаименованиеНутриента = "Витамин B12, добавленный" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB12;
						ИначеЕсли НаименованиеНутриента = "Витамин Н, Биотин" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB7;
						ИначеЕсли НаименованиеНутриента = "Витамин PP, Ниацин" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB3;
						ИначеЕсли НаименованиеНутриента = "Витамин PP, НЭ" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB3;
	
						ИначеЕсли НаименованиеНутриента = "Витамин B4, Холин" Тогда 	
	                    	Нутриент = Справочники.Нутриенты.ВитаминB4;
						ИначеЕсли НаименованиеНутриента = "Бетаин триметилглицин" Тогда  	                    		
							
						КонецЕсли; 						
						
					ИначеЕсли ТипНутриента = Перечисления.ТипыНутриентов.Минералы Тогда 
						
						Точность = 0.2;
						Разделитель 			= Найти(НаименованиеНутриента, ",");
						Наименование 			= СокрЛП(Лев(НаименованиеНутриента, Разделитель - 1));
						ИмяПредопределенного  	= СокрЛП(Прав(НаименованиеНутриента, СтрДлина(СтрокаНутриентов.Нутриент) - Разделитель));
						Нутриент 				= ПолучитьНутриентПоНаименванию(Наименование, 
																					Перечисления.ТипыНутриентов.Минералы);
					ИначеЕсли ТипНутриента = Перечисления.ТипыНутриентов.Аминокислоты Тогда
						Точность = 0.2;
						Нутриент = ПолучитьНутриентПоНаименванию(НаименованиеНутриента, Перечисления.ТипыНутриентов.Аминокислоты);
					ИначеЕсли ТипНутриента = Перечисления.ТипыНутриентов.Жиры Тогда
						
						Точность = 0.2;	
						Ом = Найти(ВРег(НаименованиеНутриента), "ОМЕГА");
						Если Ом > 0 Тогда
							МассивЧиселВСтроке = омРаботаСПростымиТипами.ПолучитьВсеЧислаВСтроке(Прав(НаименованиеНутриента, СтрДлина(СтрокаНутриентов.Нутриент) - Ом));							
							Если МассивЧиселВСтроке.Количество() > 0 Тогда
								Номер = МассивЧиселВСтроке[0];
								Если Номер = 3 Тогда
									Нутриент = Справочники.Нутриенты.Омега3;	
								ИначеЕсли Номер = 6 Тогда 	
									Нутриент = Справочники.Нутриенты.Омега6;
								КонецЕсли; 
							КонецЕсли; 
						КонецЕсли;
						
					ИначеЕсли ТипНутриента = Перечисления.ТипыНутриентов.Углеводы Тогда			
						
						Точность = 0.2;	
						Если НаименованиеНутриента = "Глюкоза" Тогда
							Нутриент = Справочники.Нутриенты.ПростыеУглеводы;	
						ИначеЕсли НаименованиеНутриента = "Фруктоза" Тогда
                        	Нутриент = Справочники.Нутриенты.ПростыеУглеводы; 	
						ИначеЕсли НаименованиеНутриента = "Галактоза" Тогда
                        	Нутриент = Справочники.Нутриенты.ПростыеУглеводы;
						ИначеЕсли НаименованиеНутриента = "Сахароза" Тогда
                        	Нутриент = Справочники.Нутриенты.СложныеУглеводы;
						ИначеЕсли НаименованиеНутриента = "Лактоза" Тогда
                        	Нутриент = Справочники.Нутриенты.СложныеУглеводы;
						ИначеЕсли НаименованиеНутриента = "Крахмал" Тогда
                        	Нутриент = Справочники.Нутриенты.СложныеУглеводы;
						ИначеЕсли НаименованиеНутриента = "Мальтоза" Тогда
                        	Нутриент = Справочники.Нутриенты.СложныеУглеводы; 						
						ИначеЕсли НаименованиеНутриента = "Сахар, добавленный" Тогда
                        	Нутриент = Справочники.Нутриенты.СложныеУглеводы;
						КонецЕсли;
						
					ИначеЕсли ТипНутриента = Перечисления.ТипыНутриентов.Прочее Тогда
						
						Точность = 0.2;	
						Если НаименованиеНутриента = "Углеводы" Тогда
                        	ИмяОбщегоПоказтеля = "Углеводы";
						ИначеЕсли НаименованиеНутриента = "Жиры" Тогда
                        	ИмяОбщегоПоказтеля = "Жиры"; 
						ИначеЕсли НаименованиеНутриента = "Белки" Тогда
                        	ИмяОбщегоПоказтеля = "Белки"; 
						Иначе
							Нутриент = ПолучитьНутриентПоНаименванию(НаименованиеНутриента, 
																					Перечисления.ТипыНутриентов.Прочее);
						КонецЕсли;   						  						
						
					КонецЕсли;  
					
					Если ЗначениеЗаполнено(Нутриент) ИЛИ ЗначениеЗаполнено(ИмяОбщегоПоказтеля) Тогда 					
					
						МассивЧисел = омРаботаСПростымиТипами.ПолучитьВсеЧислаВСтроке(Показатель);
						Если МассивЧисел.Количество() = 1 Тогда
							Количество = МассивЧисел[0];
						ИначеЕсли МассивЧисел.Количество() = 2 Тогда 
							МинКоличество 	= МассивЧисел[0];	
							МаксКоличество 	= МассивЧисел[1];
						КонецЕсли; 						
						
						Если Найти(ВРег(Показатель), "MCG") > 0 Тогда
							Делитель = 1000000;	
						ИначеЕсли Найти(ВРег(Показатель), "MG") > 0 Тогда 				
							Делитель = 1000;
						ИначеЕсли Найти(ВРег(Показатель), "UI") > 0 Тогда 				
							Делитель = 1000000 / Справочники.Нутриенты.ПолучитьКоэффициентПересчетаМЕ_в_мкг(Нутриент);
						Иначе
							Делитель = 1;
						КонецЕсли;  						
						
						Если ЗначениеЗаполнено(ИмяОбщегоПоказтеля) Тогда
							ДанныеЗаполнения[ИмяОбщегоПоказтеля] = Количество / Делитель;							 
						Иначе				 
						
							Если Количество > 0 Тогда  						
								
								Значение = Количество / Делитель;
								
								Запись 					= НаборЗаписей.Добавить();
								Запись.Нутриент			= Нутриент;
								Запись.Продукт 			= Продукт;
								Запись.Количество 		= Значение;
								Запись.МинКоличество 	= Значение * (1 - Точность);	
								Запись.МаксКоличество 	= Мин(Значение * (1 + Точность), 100);
								
							КонецЕсли;
							
							Если МаксКоличество > 0 Тогда
								
								Запись 					= НаборЗаписей.Добавить();
								Запись.Нутриент			= Нутриент;
								Запись.Продукт 			= Продукт;   							
								Запись.МинКоличество 	= МинКоличество / Делитель;	
								Запись.МаксКоличество 	= МаксКоличество / Делитель;
								Запись.Количество		= ((МинКоличество + МаксКоличество) / 2) / Делитель; 
								
							КонецЕсли; 
						
						КонецЕсли;
						
					КонецЕсли;
				
				КонецЕсли;
				
			КонецЦикла; 						
									
			Для каждого СтрокаОП Из МассивСтрокОбщихПоказателей Цикл
				
				Нутриент = Неопределено;
				Если СтрокаОП.Нутриент = "Насыщенные жиры:" Тогда
					Нутриент = Справочники.Нутриенты.НЖК;
				ИначеЕсли СтрокаОП.Нутриент = "Витамин A, RAE:" Тогда
					Нутриент = Справочники.Нутриенты.ВитаминA;
				ИначеЕсли СтрокаОП.Нутриент = "Витамин E, альфа Токоферол:" Тогда
					Нутриент = Справочники.Нутриенты.ВитаминE;
				ИначеЕсли СтрокаОП.Нутриент = "Витамин D, МЕ:" Тогда
					Нутриент = Справочники.Нутриенты.ВитаминD;
				ИначеЕсли СтрокаОП.Нутриент = "Витамин K" Тогда
					Нутриент = Справочники.Нутриенты.ВитаминK;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(Нутриент) Тогда
					
					МассивЧисел = омРаботаСПростымиТипами.ПолучитьВсеЧислаВСтроке(СтрокаОП.Количество);
					Если МассивЧисел.Количество() = 1 Тогда
						Количество = МассивЧисел[0];
					ИначеЕсли МассивЧисел.Количество() = 2 Тогда 
						МинКоличество 	= МассивЧисел[0];	
						МаксКоличество 	= МассивЧисел[1];
					КонецЕсли;
					
					Если Найти(ВРег(СтрокаОП.Количество), "MCG") > 0 Тогда
						Делитель = 1000000;	
					ИначеЕсли Найти(ВРег(СтрокаОП.Количество), "MG") > 0 Тогда 				
						Делитель = 1000;
					ИначеЕсли Найти(ВРег(СтрокаНутриентов.Количество), "UI") > 0 Тогда 				
						Делитель = 1000000 / Справочники.Нутриенты.ПолучитьКоэффициентПересчетаМЕ_в_мкг(Нутриент);
					Иначе
						Делитель = 1;
					КонецЕсли; 
					
					Если Количество > 0 Тогда  						
						
						Значение = Количество / Делитель;
						
						Запись 					= НаборЗаписей.Добавить();
						Запись.Нутриент			= Нутриент;
						Запись.Продукт 			= Продукт;
						Запись.Количество 		= Значение;
						Запись.МинКоличество 	= Значение * (1 - Точность);	
						Запись.МаксКоличество 	= Мин(Значение * (1 + Точность), 100);
						
					КонецЕсли;
					
					Если МаксКоличество > 0 Тогда
						
						Запись 					= НаборЗаписей.Добавить();
						Запись.Нутриент			= Нутриент;
						Запись.Продукт 			= Продукт;   							
						Запись.МинКоличество 	= МинКоличество / Делитель;	
						Запись.МаксКоличество 	= МаксКоличество / Делитель;
						Запись.Количество		= ((МинКоличество + МаксКоличество) / 2) / Делитель; 
						
					КонецЕсли; 
					
				КонецЕсли;
				
			КонецЦикла; 
		
			НаборЗаписей.Записать();
			
			Если ЭтоНовыйПродукт Тогда
				
				ПродуктОбъект = Продукт.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(ПродуктОбъект, ДанныеЗаполнения);
				ПродуктОбъект.Записать();
				
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОбратныйКоэффициентПересчета(Нутриент)
	
	Возврат 1000000; 
	
КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьНутриентПоНаименванию(Наименование, Тип, ДополнительныеПараметры = Неопределено)  		
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Нутриенты.Ссылка
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	Нутриенты.Тип = &Тип
		|	И (Нутриенты.Наименование = &Наименование
		|			ИЛИ Нутриенты.ПолноеНаименование ПОДОБНО &ПолноеНаименование)";
	
	Запрос.УстановитьПараметр("Тип", Тип);	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.УстановитьПараметр("ПолноеНаименование", "%" + Наименование + "%");
	//Запрос.УстановитьПараметр("ИмяПредопределенного", ?(ТипЗнч(ДополнительныеПараметры) = Тип("Структура"), ДополнительныеПараметры.ИмяПредопределенного, ""));
	 
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Результат = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;
		
	КонецЕсли; 
	
	Возврат Результат;
		
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПродуктПоНаименованию(Наименование, Источник, ЭтоНовыйПродукт)  		
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПродуктыПитания.Ссылка
		|ИЗ
		|	Справочник.ПродуктыПитания КАК ПродуктыПитания
		|ГДЕ
		|	ПродуктыПитания.Наименование = &Наименование
		|	И ПродуктыПитания.Источник = &Источник";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.УстановитьПараметр("Источник", Источник);
	
	РезультатЗапроса = Запрос.Выполнить(); 	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать(); 	
	
	Если НЕ РезультатЗапроса.Пустой() Тогда 
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Результат = ВыборкаДетальныеЗаписи.Ссылка;	
		КонецЕсли;  
		ЭтоНовыйПродукт = Ложь;
	Иначе
		НовыйПродуктПитания 				= Справочники.ПродуктыПитания.СоздатьЭлемент();
		НовыйПродуктПитания.Наименование 	= Наименование; 	
		НовыйПродуктПитания.Источник		= Источник;		
		НовыйПродуктПитания.Записать();
		
		Результат = НовыйПродуктПитания.Ссылка; 
		ЭтоНовыйПродукт = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
 



 



