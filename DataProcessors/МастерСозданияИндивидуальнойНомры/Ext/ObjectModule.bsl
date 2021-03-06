﻿Процедура ЗаполнитьПоказателиМужчины_МР231243108() Экспорт
	
	Макет 				= ЭтотОбъект.ПолучитьМакет("МР231243108_НФПЭПВМ");
	Ит 					= 6;
	ТипНутриента		= Неопределено;
	ТаблицаКалорийности = Новый Соответствие;
	
	//Взрослые(0 -  (18-29), 1 - (30-39), 2 - (40-59), 3 - >60), 
	//Подростки (4 - (0-3 мес.), 5 - (4-6 мес.), 6 - (7-12 мес.), 7 - (1-2 года), 
	//8 - (2-3), 9 - (3-7), 10 - (7-11), 11- (11-14), 12 - (14-18))
	
	//М - Мужчина, Ж - Женцина, [М,Ж]П - Подросток, БК - Беременные/Кормящие  
	
	Пока Истина Цикл   		
		
		НомерСтроки 				= Ит;
		ДанныеЗаполнения 			= Новый Структура("Категория, Возраст, ГруппаФизАктивности, Нутриент, ТипНутриента, Количество, МинКоличество, МаксКоличество", "М");		
		АдресНутриент				= "R" + Формат(НомерСтроки,"ЧГ=") + "C2";
		АдресТипНутриента			= "R" + Формат(НомерСтроки,"ЧГ=") + "C3:R" + Формат(НомерСтроки,"ЧГ=") + "C18"; 		 
		НутриентТекст				= Макет.Область(АдресНутриент).Текст;
		ТипНутриентаТекст 			= Макет.Область(АдресТипНутриента).Текст;
		ЗначениеВПредКолонке 		= 0; 
		Параметр 					= 100;
		РасчетПоказателяВПроцентах 	= Ложь;	
		
		Ит = Ит + 1;
		//Найти(НутриентТекст, "Медь") > 0
		Если ТипНутриентаТекст = "Витамины" Тогда
			ТипНутриента = Перечисления.ТипыНутриентов.Витамины;	
		ИначеЕсли ТипНутриентаТекст = "Минеральные вещества" Тогда
			ТипНутриента = Перечисления.ТипыНутриентов.Минералы;		
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НутриентТекст) Тогда
			Если НЕ ЗначениеЗаполнено(ТипНутриентаТекст) Тогда
				Прервать;	
			КонецЕсли; 			
			Продолжить;	
		КонецЕсли;		 
		
		Делитель = ЗаполнитьДанныеПоНутриенту(ДанныеЗаполнения, НутриентТекст, ТипНутриента, РасчетПоказателяВПроцентах);
		
		Если Не ЗначениеЗаполнено(ДанныеЗаполнения.Нутриент) Тогда
			Продолжить;	
		КонецЕсли;  		 
		
		Для НомерКолонки = 3 По 18 Цикл  			
			 				
			АдресЗначение 	= "R" + Формат(НомерСтроки,"ЧГ=") + "C" + Формат(НомерКолонки,"ЧГ=");
			ТекОбласть		= Макет.Область(АдресЗначение);
			ОбластьЗначение = ТекОбласть.Текст;
			
			ДанныеЗаполнения.Количество 	= 0;
			ДанныеЗаполнения.МинКоличество 	= 0;
			ДанныеЗаполнения.МаксКоличество = 0;
			ДанныеЗаполнения.Возраст		= -1;
			
			Если ЕстьЧислаВСтроке(ОбластьЗначение) Тогда
				ЗначениеВПредКолонке = ОбластьЗначение;	
			КонецЕсли;  
			
			Если НомерКолонки < 6 Тогда
				ДанныеЗаполнения.ГруппаФизАктивности = 1;	
			ИначеЕсли НомерКолонки < 9 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 2;
			ИначеЕсли НомерКолонки < 12 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 3;
			ИначеЕсли НомерКолонки < 15 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 4;
			ИначеЕсли НомерКолонки < 18 Тогда
				ДанныеЗаполнения.ГруппаФизАктивности = 5;
			ИначеЕсли НомерКолонки = 18 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 0;
				ДанныеЗаполнения.Возраст = 3;
			КонецЕсли;  
			
			Если ДанныеЗаполнения.Возраст < 0 Тогда
				Если НомерКолонки % 3 = 0 Тогда
					ДанныеЗаполнения.Возраст = 0;
				ИначеЕсли (НомерКолонки - 4) % 3 = 0 Тогда 
					ДанныеЗаполнения.Возраст = 1;
				ИначеЕсли (НомерКолонки - 5) % 3 = 0 Тогда 
					ДанныеЗаполнения.Возраст = 2;
				КонецЕсли;	
			КонецЕсли; 
			
			Если РасчетПоказателяВПроцентах Тогда
				Параметр = ТаблицаКалорийности.Получить(НомерКолонки);		
			КонецЕсли; 
			
			ТекстЗначение = ?(ЗначениеЗаполнено(ОбластьЗначение), ОбластьЗначение, 
												?(ТекОбласть.ГраницаСлева.ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, ЗначениеВПредКолонке, "0"));
						 												
			ЗаполнитьПоказательНутриента(ДанныеЗаполнения, ТекстЗначение, Делитель, Параметр);				
			
			//запоминаю калорийность для каждого столбца
			Если ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Калорийность Тогда
				ТаблицаКалорийности.Вставить(НомерКолонки, ДанныеЗаполнения.Количество);			
			КонецЕсли;		 
			
			Если ДанныеЗаполнения.Количество <> 0 ИЛИ ДанныеЗаполнения.МаксКоличество <> 0 Тогда  				
				ДобавитьСтрокуВКоллекцию(ТаблицаДанныхПоказателейМР231243108, ДанныеЗаполнения);	
			КонецЕсли; 			 			
			
		КонецЦикла; 
		
	КонецЦикла;	
	
КонецПроцедуры

Процедура ЗаполнитьПоказателиЖенщины_МР231243108() Экспорт
	
	Макет 				= ЭтотОбъект.ПолучитьМакет("МР231243108_НФПЭПВЖ");
	Ит 					= 6;
	ТипНутриента		= Неопределено;
	ТаблицаКалорийности = Новый Соответствие;
	
	//Взрослые(0 -  (18-29), 1 - (30-39), 2 - (40-59), 3 - >60), 	
	//М - Мужчина, Ж - Женцина, [М,Ж]П - Подросток, БК - Беременные/Кормящие  
	
	Пока Истина Цикл   		
		
		НомерСтроки 				= Ит;
		ДанныеЗаполнения 			= Новый Структура("Категория, Возраст, ГруппаФизАктивности, Нутриент, ТипНутриента, Количество, МинКоличество, МаксКоличество", "Ж");		
		АдресНутриент				= "R" + Формат(НомерСтроки,"ЧГ=") + "C2";
		АдресТипНутриента			= "R" + Формат(НомерСтроки,"ЧГ=") + "C3:R" + Формат(НомерСтроки,"ЧГ=") + "C15"; 		 
		НутриентТекст				= Макет.Область(АдресНутриент).Текст;
		ТипНутриентаТекст 			= Макет.Область(АдресТипНутриента).Текст;
		ЗначениеВПредКолонке 		= 0; 
		Параметр 					= 100;
		РасчетПоказателяВПроцентах 	= Ложь;	
		
		Ит = Ит + 1;
		
		Если ТипНутриентаТекст = "Витамины" Тогда
			ТипНутриента = Перечисления.ТипыНутриентов.Витамины;	
		ИначеЕсли ТипНутриентаТекст = "Минеральные вещества" Тогда
			ТипНутриента = Перечисления.ТипыНутриентов.Минералы;		
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НутриентТекст) Тогда
			Если НЕ ЗначениеЗаполнено(ТипНутриентаТекст) Тогда
				Прервать;	
			КонецЕсли; 			
			Продолжить;	
		КонецЕсли;		 
		
		Делитель = ЗаполнитьДанныеПоНутриенту(ДанныеЗаполнения, НутриентТекст, ТипНутриента, РасчетПоказателяВПроцентах);
		
		Если Не ЗначениеЗаполнено(ДанныеЗаполнения.Нутриент) Тогда
			Продолжить;	
		КонецЕсли;  		 
		
		Для НомерКолонки = 3 По 15 Цикл  			
			 				
			АдресЗначение 	= "R" + Формат(НомерСтроки,"ЧГ=") + "C" + Формат(НомерКолонки,"ЧГ=");
			ТекОбласть		= Макет.Область(АдресЗначение);
			ОбластьЗначение = ТекОбласть.Текст;
			
			ДанныеЗаполнения.Количество 	= 0;
			ДанныеЗаполнения.МинКоличество 	= 0;
			ДанныеЗаполнения.МаксКоличество = 0;
			ДанныеЗаполнения.Возраст		= -1;
			
			Если ЕстьЧислаВСтроке(ОбластьЗначение) Тогда
				ЗначениеВПредКолонке = ОбластьЗначение;	
			КонецЕсли;  
			
			Если НомерКолонки < 6 Тогда
				ДанныеЗаполнения.ГруппаФизАктивности = 1;	
			ИначеЕсли НомерКолонки < 9 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 2;
			ИначеЕсли НомерКолонки < 12 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 3;
			ИначеЕсли НомерКолонки < 15 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 4;			
			ИначеЕсли НомерКолонки = 15 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 0;
				ДанныеЗаполнения.Возраст = 3;
			КонецЕсли;  
			
			Если ДанныеЗаполнения.Возраст < 0 Тогда
				Если НомерКолонки % 3 = 0 Тогда
					ДанныеЗаполнения.Возраст = 0;
				ИначеЕсли (НомерКолонки - 4) % 3 = 0 Тогда 
					ДанныеЗаполнения.Возраст = 1;
				ИначеЕсли (НомерКолонки - 5) % 3 = 0 Тогда 
					ДанныеЗаполнения.Возраст = 2;
				КонецЕсли;	
			КонецЕсли; 
			
			Если РасчетПоказателяВПроцентах Тогда
				Параметр = ТаблицаКалорийности.Получить(НомерКолонки);		
			КонецЕсли; 
			
			ТекстЗначение = ?(ЗначениеЗаполнено(ОбластьЗначение), ОбластьЗначение, 
												?(ТекОбласть.ГраницаСлева.ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, ЗначениеВПредКолонке, "0"));
						 												
			ЗаполнитьПоказательНутриента(ДанныеЗаполнения, ТекстЗначение, Делитель, Параметр);				
			
			//запоминаю калорийность для каждого столбца
			Если ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Калорийность Тогда
				ТаблицаКалорийности.Вставить(НомерКолонки, ДанныеЗаполнения.Количество);			
			КонецЕсли; 
			
			Если ДанныеЗаполнения.Количество <> 0 ИЛИ ДанныеЗаполнения.МаксКоличество <> 0 Тогда 				
				ДобавитьСтрокуВКоллекцию(ТаблицаДанныхПоказателейМР231243108, ДанныеЗаполнения);	
			КонецЕсли; 			 			
			
		КонецЦикла; 
		
	КонецЦикла;		
	
КонецПроцедуры   

Процедура ЗаполнитьПоказателиПодростки_МР231243108()Экспорт
	
	Макет 				= ЭтотОбъект.ПолучитьМакет("МР231243108_НФПЭПВП");
	Ит 					= 9;
	ТипНутриента		= Неопределено;
	ТаблицаКалорийности = Новый Соответствие;
	
	//Подростки (4 - (0-3 мес.), 5 - (4-6 мес.), 6 - (7-12 мес.), 7 - (1-2 года), 
	//8 - (2-3), 9 - (3-7), 10 - (7-11), 11- (11-14), 12 - (14-18)) 	
	//М - Мужчина, Ж - Женцина, [М,Ж]П - Подросток, БК - Беременные/Кормящие  
	
	Пока Истина Цикл   		
		
		НомерСтроки 				= Ит;
		ДанныеЗаполнения 			= Новый Структура("Категория, Возраст, ГруппаФизАктивности, Нутриент, ТипНутриента, Количество, МинКоличество, МаксКоличество", "П",,0);		
		АдресНутриент				= "R" + Формат(НомерСтроки,"ЧГ=") + "C2";
		АдресТипНутриента			= "R" + Формат(НомерСтроки,"ЧГ=") + "C3:R" + Формат(НомерСтроки,"ЧГ=") + "C13"; 		 
		НутриентТекст				= Макет.Область(АдресНутриент).Текст;
		ТипНутриентаТекст 			= Макет.Область(АдресТипНутриента).Текст;
		ЗначениеВПредКолонке 		= 0; 
		Параметр 					= 100;
		РасчетПоказателяВПроцентах 	= Ложь;	
		Пол 						= "";
		
		Ит = Ит + 1;
		
		Если ТипНутриентаТекст = "Витамины" Тогда
			ТипНутриента = Перечисления.ТипыНутриентов.Витамины;	
		ИначеЕсли ТипНутриентаТекст = "Минеральные вещества" Тогда
			ТипНутриента = Перечисления.ТипыНутриентов.Минералы;		
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НутриентТекст) Тогда
			Если НЕ ЗначениеЗаполнено(ТипНутриентаТекст) Тогда
				Прервать;	
			КонецЕсли; 			
			Продолжить;	
		КонецЕсли;		 
		
		Делитель = ЗаполнитьДанныеПоНутриенту(ДанныеЗаполнения, НутриентТекст, ТипНутриента, РасчетПоказателяВПроцентах);
		
		Если Не ЗначениеЗаполнено(ДанныеЗаполнения.Нутриент) Тогда
			Продолжить;	
		КонецЕсли;  		 
		
		Для НомерКолонки = 3 По 13 Цикл  			
			 				
			АдресЗначение 	= "R" + Формат(НомерСтроки,"ЧГ=") + "C" + Формат(НомерКолонки,"ЧГ=");
			ТекОбласть		= Макет.Область(АдресЗначение);
			ОбластьЗначение = ТекОбласть.Текст;
			
			ДанныеЗаполнения.Количество 	= 0;
			ДанныеЗаполнения.МинКоличество 	= 0;
			ДанныеЗаполнения.МаксКоличество = 0;
			ДанныеЗаполнения.Возраст		= -1;
			
			Если ЕстьЧислаВСтроке(ОбластьЗначение) Тогда
				ЗначениеВПредКолонке = ОбластьЗначение;	
			КонецЕсли;  
			
			Если НомерКолонки < 10 Тогда
				ДанныеЗаполнения.Возраст = НомерКолонки + 1; 				
			Иначе
				Если НомерКолонки < 12 Тогда
					ДанныеЗаполнения.Возраст = 11;
				ИначеЕсли НомерКолонки < 14 Тогда 
					ДанныеЗаполнения.Возраст = 12;
				КонецЕсли; 
				
				Если НомерКолонки % 2 = 0 Тогда
					Пол = "М";
				Иначе
					Пол = "Ж";
				КонецЕсли; 
			КонецЕсли; 			 
			
			Если РасчетПоказателяВПроцентах Тогда
				Параметр = ТаблицаКалорийности.Получить(НомерКолонки);		
			КонецЕсли; 
			
			ТекстЗначение = ?(ЗначениеЗаполнено(ОбластьЗначение), ОбластьЗначение, 
												?(ТекОбласть.ГраницаСлева.ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, ЗначениеВПредКолонке, "0"));
						 												
			ЗаполнитьПоказательНутриента(ДанныеЗаполнения, ТекстЗначение, Делитель, Параметр);				
			
			//запоминаю калорийность для каждого столбца
			Если ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Калорийность Тогда
				ТаблицаКалорийности.Вставить(НомерКолонки, ДанныеЗаполнения.Количество);			
			КонецЕсли; 			
			
			Если ДанныеЗаполнения.Количество <> 0 ИЛИ ДанныеЗаполнения.МаксКоличество <> 0 Тогда 				
				
				Если ЗначениеЗаполнено(Пол) Тогда
					ДанныеЗаполнения.Категория = Пол + ДанныеЗаполнения.Категория;
					ДобавитьСтрокуВКоллекцию(ТаблицаДанныхПоказателейМР231243108, ДанныеЗаполнения);
				Иначе
					ДанныеЗаполнения.Категория = "МП";
					ДобавитьСтрокуВКоллекцию(ТаблицаДанныхПоказателейМР231243108, ДанныеЗаполнения);
					ДанныеЗаполнения.Категория = "ЖП";
					ДобавитьСтрокуВКоллекцию(ТаблицаДанныхПоказателейМР231243108, ДанныеЗаполнения);
				КонецЕсли; 
					
			КонецЕсли; 			 			
			
		КонецЦикла; 
		
	КонецЦикла;				
	
КонецПроцедуры

Процедура ЗаполнитьПоказателиДополнительные_МР231243108() Экспорт
	
	Макет 				= ЭтотОбъект.ПолучитьМакет("МР231243108_ДПЭПВЖБК");
	Ит 					= 3;
	ТипНутриента		= Неопределено;	 	
	 	
	//М - Мужчина, Ж - Женцина, [М,Ж]П - Подросток, БК - Беременные/Кормящие  
	
	Пока Истина Цикл   		
		
		НомерСтроки 				= Ит;
		ДанныеЗаполнения 			= Новый Структура("Категория, Возраст, ГруппаФизАктивности, Нутриент, ТипНутриента, Количество, МинКоличество, МаксКоличество", "БК");		
		АдресНутриент				= "R" + Формат(НомерСтроки,"ЧГ=") + "C2";
		АдресТипНутриента			= "R" + Формат(НомерСтроки,"ЧГ=") + "C3:R" + Формат(НомерСтроки,"ЧГ=") + "C5"; 		 
		НутриентТекст				= Макет.Область(АдресНутриент).Текст;
		ТипНутриентаТекст 			= Макет.Область(АдресТипНутриента).Текст;
		ЗначениеВПредКолонке 		= 0; 
		Параметр 					= 100;
		РасчетПоказателяВПроцентах 	= Ложь;			
		
		Ит = Ит + 1;
		
		Если ТипНутриентаТекст = "Витамины" Тогда
			ТипНутриента = Перечисления.ТипыНутриентов.Витамины;	
		ИначеЕсли ТипНутриентаТекст = "Минеральные вещества" Тогда
			ТипНутриента = Перечисления.ТипыНутриентов.Минералы;		
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НутриентТекст) Тогда
			Если НЕ ЗначениеЗаполнено(ТипНутриентаТекст) Тогда
				Прервать;	
			КонецЕсли; 			
			Продолжить;	
		КонецЕсли;		 
		
		Делитель = ЗаполнитьДанныеПоНутриенту(ДанныеЗаполнения, НутриентТекст, ТипНутриента, РасчетПоказателяВПроцентах);
		
		Если Не ЗначениеЗаполнено(ДанныеЗаполнения.Нутриент) Тогда
			Продолжить;	
		КонецЕсли;  		 
		
		Для НомерКолонки = 3 По 5 Цикл  			
			 				
			АдресЗначение 	= "R" + Формат(НомерСтроки,"ЧГ=") + "C" + Формат(НомерКолонки,"ЧГ=");
			ТекОбласть		= Макет.Область(АдресЗначение);
			ОбластьЗначение = ТекОбласть.Текст;
			
			ДанныеЗаполнения.Количество 	= 0;
			ДанныеЗаполнения.МинКоличество 	= 0;
			ДанныеЗаполнения.МаксКоличество = 0; 			
			
			Если ЕстьЧислаВСтроке(ОбластьЗначение) Тогда
				ЗначениеВПредКолонке = ОбластьЗначение;	
			КонецЕсли;  
			
			Если НомерКолонки = 3 Тогда
				ДанныеЗаполнения.ГруппаФизАктивности = 1;	
			ИначеЕсли НомерКолонки = 4 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 2;
			ИначеЕсли НомерКолонки = 5 Тогда 
				ДанныеЗаполнения.ГруппаФизАктивности = 3;			
			КонецЕсли; 				 
			
			ТекстЗначение = ?(ЗначениеЗаполнено(ОбластьЗначение), ОбластьЗначение, 
												?(ТекОбласть.ГраницаСлева.ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, ЗначениеВПредКолонке, "0"));
						 												
			ЗаполнитьПоказательНутриента(ДанныеЗаполнения, ТекстЗначение, Делитель, Параметр);				  			
			
			Если ДанныеЗаполнения.Количество <> 0 ИЛИ ДанныеЗаполнения.МаксКоличество <> 0 Тогда 				
				ДобавитьСтрокуВКоллекцию(ТаблицаДанныхПоказателейМР231243108, ДанныеЗаполнения);  					
			КонецЕсли; 			 			
			
		КонецЦикла; 
		
	КонецЦикла;	
	
КонецПроцедуры

Процедура ЗаполнитьПоказателиБАВ_МР231243108() Экспорт
	
	//не стал парсить ТД из-за ерунды
	
	МассивКатегорий = Новый Массив;
	МассивКатегорий.Добавить("М");
	МассивКатегорий.Добавить("Ж"); 	
	
	//заполняю для взрослых
	СНП	= Новый Соответствие;
	СНП.Вставить(Справочники.Нутриенты.ВитаминB4, 0.5);
	СНП.Вставить(Справочники.Нутриенты.Co, 0.00001);
	СНП.Вставить(Справочники.Нутриенты.Si, 0.03);
	
	Для каждого Категория Из МассивКатегорий Цикл
		Для Лета = 0 По 3 Цикл
			Для ГруппаФизАктивности = 1 По 5 Цикл 	
				
				Если ГруппаФизАктивности = 5 И Категория = "Ж" Тогда
					Продолжить;	
				КонецЕсли; 
				
				Для каждого БАВ Из СНП Цикл
					
					ДанныеЗаполнения 						= Новый Структура("Категория, Возраст, ГруппаФизАктивности, Нутриент, ТипНутриента, Количество, МинКоличество, МаксКоличество");
					ДанныеЗаполнения.Категория 				= Категория;
					ДанныеЗаполнения.Возраст   				= Лета;
					ДанныеЗаполнения.ГруппаФизАктивности   	= ГруппаФизАктивности;
					ДанныеЗаполнения.Нутриент   			= БАВ.Ключ;
					ДанныеЗаполнения.Количество   			= БАВ.Значение;
					
					Если ТипЗнч(ДанныеЗаполнения.Нутриент) = Тип("Строка") Тогда
						ДанныеЗаполнения.ТипНутриента = Перечисления.ТипыНутриентов.МакроНутриенты;
					Иначе
						ДанныеЗаполнения.ТипНутриента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ДанныеЗаполнения.Нутриент, "Тип");	
					КонецЕсли;
					
					ДобавитьСтрокуВКоллекцию(ТаблицаДанныхПоказателейМР231243108, ДанныеЗаполнения);
					
				КонецЦикла; 
			КонецЦикла; 			
		КонецЦикла;  	
	КонецЦикла;
	
	//заполняю для детей
	//Подростки (4 - (0-3 мес.), 5 - (4-6 мес.), 6 - (7-12 мес.), 7 - (1-2 года), 
	//8 - (2-3), 9 - (3-7), 10 - (7-11), 11- (11-14), 12 - (14-18))
	Для каждого Категория Из МассивКатегорий Цикл	
		Для Лета = 4 По 12 Цикл
			
			Если Возраст < 7 Тогда
				МинПоказатель = 0.05;
				МаксПоказатель = 0.07;
			ИначеЕсли Возраст < 9 Тогда
				МинПоказатель = 0.07;
				МаксПоказатель = 0.09;
			ИначеЕсли Возраст = 9 Тогда
				МинПоказатель = 0.1;
				МаксПоказатель = 0.2;
			Иначе
				МинПоказатель = 0.2;
				МаксПоказатель = 0.5;
			КонецЕсли; 
			
			ДанныеЗаполнения 						= Новый Структура("Категория, Возраст, ГруппаФизАктивности, Нутриент, ТипНутриента, Количество, МинКоличество, МаксКоличество");
			ДанныеЗаполнения.Категория 				= Категория + "П";
			ДанныеЗаполнения.Возраст   				= Лета; 			
			ДанныеЗаполнения.Нутриент   			= Справочники.Нутриенты.ВитаминB4;
			ДанныеЗаполнения.МинКоличество   		= МинПоказатель;
			ДанныеЗаполнения.МаксКоличество   		= МаксПоказатель; 			
			
			ДобавитьСтрокуВКоллекцию(ТаблицаДанныхПоказателейМР231243108, ДанныеЗаполнения);
			
		КонецЦикла	
	КонецЦикла;
	
КонецПроцедуры 

Процедура ЗаполнитьПоказателиАминокислотыМЩ() Экспорт	
	
	ПоляЗаполнения = "Нутриент, Количество, МинКоличество, МаксКоличество, ТипНутриента";
	
	МассивПолейСтрок = Новый Массив;
	МассивПолейСтрок.Добавить(Новый Структура(ПоляЗаполнения, Справочники.Нутриенты.Изолейцин, 2.1,,, Перечисления.ТипыНутриентов.Аминокислоты));
	МассивПолейСтрок.Добавить(Новый Структура(ПоляЗаполнения, Справочники.Нутриенты.Лизин, 4.1,,, Перечисления.ТипыНутриентов.Аминокислоты));
	МассивПолейСтрок.Добавить(Новый Структура(ПоляЗаполнения, Справочники.Нутриенты.Лейцин, 4.6,,, Перечисления.ТипыНутриентов.Аминокислоты));
	МассивПолейСтрок.Добавить(Новый Структура(ПоляЗаполнения, Справочники.Нутриенты.Метионин, 1.8,,, Перечисления.ТипыНутриентов.Аминокислоты));
	МассивПолейСтрок.Добавить(Новый Структура(ПоляЗаполнения, Справочники.Нутриенты.Фенилаланин, 4.4,,, Перечисления.ТипыНутриентов.Аминокислоты));
	МассивПолейСтрок.Добавить(Новый Структура(ПоляЗаполнения, Справочники.Нутриенты.Треонин,, 0.5, 2.4, Перечисления.ТипыНутриентов.Аминокислоты));
	МассивПолейСтрок.Добавить(Новый Структура(ПоляЗаполнения, Справочники.Нутриенты.Триптофан, 0.8,,, Перечисления.ТипыНутриентов.Аминокислоты));
	МассивПолейСтрок.Добавить(Новый Структура(ПоляЗаполнения, Справочники.Нутриенты.Валин, 2.5,,, Перечисления.ТипыНутриентов.Аминокислоты));
	
	Для каждого Ит Из МассивПолейСтрок Цикл
		ДобавитьСтрокуВКоллекцию(ТаблицаДанныхПоказателейМЩ, Ит);	
	КонецЦикла; 				
	
КонецПроцедуры  

Функция ДобавитьСтрокуВКоллекцию(КоллекцияСтрок, СтруктураПолейСтроки)
	
	НоваяСтрока = КоллекцияСтрок.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПолейСтроки);
	Возврат НоваяСтрока;	
	
КонецФункции  

Процедура ЗаполнитьПоказательНутриента(ДанныеЗаполнения, ТекстЗначение, Делитель = 1, Значение = 100)  	
	
	Параметр = 1;
	 	
	Если Значение <> 100 Тогда //есть корректировка количества нутриента по калорийности
		
		Если ДанныеЗаполнения.ТипНутриента = Перечисления.ТипыНутриентов.Жиры ИЛИ 
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Жиры Тогда
			Коэф = 9;
		Иначе 
			Коэф = 4;  					
		КонецЕсли;
		
		Параметр = Значение / Коэф / 100;		
		
	КонецЕсли; 	
	
	МассивЧисел = омРаботаСПростымиТипами.ПолучитьВсеЧислаВСтроке(ТекстЗначение);
	Если МассивЧисел.Количество() = 1 Тогда
		ДанныеЗаполнения.Количество = МассивЧисел[0] * Параметр / Делитель;
	ИначеЕсли МассивЧисел.Количество() = 2 Тогда 
		ДанныеЗаполнения.МинКоличество = МассивЧисел[0] * Параметр / Делитель;
		ДанныеЗаполнения.МаксКоличество = МассивЧисел[1] * Параметр / Делитель; 	
	КонецЕсли;
	
КонецПроцедуры

Функция ЗаполнитьДанныеПоНутриенту(ДанныеЗаполнения, НутриентТекст, ТипНутриента, РасчетПоказателяВПроцентах)
	
	Результат 					= 1;
	РасчетПоказателяВПроцентах 	= Ложь;
	
	Разделитель = Найти(НутриентТекст, ",");
	
	Если Разделитель = 0 Тогда
		Наименование = СокрЛП(НутриентТекст); 
	Иначе
		
		Наименование 			= СокрЛП(Лев(НутриентТекст, Разделитель - 1));
		ТекстПослеРазделителя  	= СокрЛП(Прав(НутриентТекст, СтрДлина(НутриентТекст) - Разделитель));   
		
		Если Найти(ВРег(ТекстПослеРазделителя), "МКГ") > 0 Тогда
			Результат = 1000000;	
		ИначеЕсли Найти(ВРег(ТекстПослеРазделителя), "МГ") > 0 Тогда 				
			Результат = 1000;
		ИначеЕсли Найти(ВРег(ТекстПослеРазделителя), "%") > 0 Тогда 
			РасчетПоказателяВПроцентах = Истина;
			Результат = 1;		
		Иначе
			Результат = 1;
		КонецЕсли;	
		
	КонецЕсли; 	
		
	Если ТипНутриента = Перечисления.ТипыНутриентов.Витамины Тогда
		 ДанныеЗаполнения.Нутриент = ПолучитьНутриентПоНаименванию(Наименование, ТипНутриента); 	
	ИначеЕсли ТипНутриента = Перечисления.ТипыНутриентов.Минералы Тогда 
		 ДанныеЗаполнения.Нутриент = ПолучитьНутриентПоНаименванию(Наименование, ТипНутриента);	
	Иначе
		Если Наименование = "Энергия" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Калорийность;	
		ИначеЕсли Наименование = "Белок" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Белки;
		ИначеЕсли Наименование = "в т.ч. животный" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Белки;
		ИначеЕсли Наименование = "Белки" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Белки;
		ИначеЕсли Наименование = "Жир" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Жиры; 
		ИначеЕсли Наименование = "Пищевые волокна" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.ПищевыеВолокна;  
		ИначеЕсли Наименование = "Жиры" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Жиры;
		ИначеЕсли Наименование = "МНЖК" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.МНЖК;
		ИначеЕсли Наименование = "Омега-6" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Омега6;
		ИначеЕсли Наименование = "Омега-3" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Омега3;
		ИначеЕсли Наименование = "Углеводы" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Углеводы;    			
		ИначеЕсли Наименование = "Сахар" Тогда
			ДанныеЗаполнения.Нутриент = Справочники.Нутриенты.Углеводы;	
		КонецЕсли; 	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения.Нутриент) Тогда
		ДанныеЗаполнения.ТипНутриента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ДанныеЗаполнения.Нутриент, "Тип");	
	КонецЕсли;   	
	
	Возврат Результат;
	
КонецФункции   

Функция ПолучитьНутриентПоНаименванию(Наименование, Тип)  		
	
	Результат = Неопределено;
	Запрос = Новый Запрос;
	
	Если ЗначениеЗаполнено(Тип) Тогда 		
		
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
		
	Иначе   		
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Нутриенты.Ссылка
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	 (Нутриенты.Наименование = &Наименование
		|			ИЛИ Нутриенты.ПолноеНаименование ПОДОБНО &ПолноеНаименование)"; 		
			
		Запрос.УстановитьПараметр("Наименование", Наименование);
		Запрос.УстановитьПараметр("ПолноеНаименование", "%" + Наименование + "%");
		
	КонецЕсли; 
	
	  	
	 
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Результат = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;
		
	КонецЕсли; 
	
	Возврат Результат;
		
КонецФункции

Функция ЕстьЧислаВСтроке(пСтрока) 	
	
	МассивЧисел = омРаботаСПростымиТипами.ПолучитьВсеЧислаВСтроке(пСтрока); 	 	
	
	Возврат МассивЧисел.Количество() > 0;
	
КонецФункции
 
 
