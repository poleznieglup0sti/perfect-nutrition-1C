﻿&НаКлиенте
Перем Эксель, Книга;   

&НаКлиенте
Процедура ЗагруритьНорму(Команда)
	
	ОткрытьФорму("Справочник.НормыНутриентов.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ЗагруритьНормуЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс); 
	
КонецПроцедуры  

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	ЗагрузитьДанныеНаСервере();
КонецПроцедуры 

&НаКлиенте
Функция ИмяЛиста(НомерЛиста)
	
	Попытка
		ИмяЛиста = Книга.Sheets(НомерЛиста).Name;
		Возврат ИмяЛиста;
		
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат "";
	
КонецФункции

&НаКлиенте
Процедура ПолучитьДанныеИзФайла(Команда)   	
	
	Объект.СписокПродуктов.Очистить();
	Объект.ХимСостав.Очистить();
	
	Листы = Книга.Sheets;
	Для НомерЛиста = 1 По Листы.Count - 1 Цикл 			
		
		ИмяЛистаЭксель = ИмяЛиста(НомерЛиста);
		
		Попытка
			ЛистЭксель = Книга.Sheets(ИмяЛистаЭксель);	
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить();
		КонецПопытки;
		
		КоличествоКолонок 		= ЛистЭксель.Cells(1,1).SpecialCells(11).Column;
		КоличествоСтрок 		= ЛистЭксель.Cells(1,1).SpecialCells(11).Row; 	
		
		Область = ЛистЭксель.Range(ЛистЭксель.Cells(1,1), ЛистЭксель.Cells(КоличествоСтрок, КоличествоКолонок));
		
		Если Область.Value <> Неопределено Тогда
			
			ДанныеЭксель = Область.Value.Выгрузить();					
			
			Для НомерКолонки = 3 По КоличествоКолонок - 1 Цикл  
				
				НовыйПродукт 				= Объект.СписокПродуктов.Добавить();
				НовыйПродукт.Группа			= ИмяЛистаЭксель;				
				НомерСтроки 			 	= 3;  		  			
				ТипНутриента 			 	= Неопределено;
				Продукт 					= ?(ЗначениеЗаполнено(ДанныеЭксель[НомерКолонки][0]), СокрЛП(ДанныеЭксель[НомерКолонки][0]), Продукт) ;
				Состояние 					= СокрЛП(ДанныеЭксель[НомерКолонки][1]);
				НаименованиеПродукта	 	= Продукт + " " + Состояние;
				НовыйПродукт.Наименование	= НаименованиеПродукта;
				
				Пока НомерСтроки < КоличествоСтрок И ЗначениеЗаполнено(ДанныеЭксель[0][НомерСтроки]) Цикл 				
					
					ТребуетсяОбработкаСтроки 	= Истина;
					Наименование 				= СокрЛП(ДанныеЭксель[0][НомерСтроки]);
					Количество	 				= СокрЛП(ДанныеЭксель[НомерКолонки][НомерСтроки]); 				
					
					Если Наименование = "Общие" Тогда
						ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Прочее");	
						ТребуетсяОбработкаСтроки = Ложь;
					ИначеЕсли Наименование = "Минералы" Тогда 
						ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Минералы");
						ТребуетсяОбработкаСтроки = Ложь;  
					ИначеЕсли Наименование = "Витамины" Тогда
						ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Витамины");
						ТребуетсяОбработкаСтроки = Ложь;  
					ИначеЕсли Наименование = "Жирные кислоты" Тогда
						ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Жиры");
						ТребуетсяОбработкаСтроки = Ложь;  
					ИначеЕсли Наименование = "Аминокислоты" Тогда
						ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Аминокислоты");
						ТребуетсяОбработкаСтроки = Ложь; 
					КонецЕсли; 	
					
					Если Не ЗначениеЗаполнено(Количество) Тогда
						ТребуетсяОбработкаСтроки = Ложь;	
					КонецЕсли;
					
					Если ТребуетсяОбработкаСтроки Тогда 				 
						
						Если ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Прочее") Тогда
							
							Если Наименование = "Вода, г" Тогда
								ДобавитьЭлементХимСостава(НаименованиеПродукта, Наименование, Количество, ТипНутриента);	
							ИначеЕсли Наименование = "Энергия, кКал" Тогда 
								НовыйПродукт.Калорийность = Количество;	
							ИначеЕсли Наименование = "Белки, г" Тогда 
								НовыйПродукт.Белки = Количество;
							ИначеЕсли Наименование = "Жиры, г" Тогда 
								НовыйПродукт.Жиры = Количество;
							ИначеЕсли Наименование = "Углеводы, г" Тогда
								НовыйПродукт.Углеводы = Количество;
							ИначеЕсли Наименование = "Волокна, г" Тогда 			
								ДобавитьЭлементХимСостава(НаименованиеПродукта, Наименование, Количество, ТипНутриента);
							КонецЕсли;	
							
						Иначе
							ДобавитьЭлементХимСостава(НаименованиеПродукта, Наименование, Количество, ТипНутриента);					
						КонецЕсли; 
						
					КонецЕсли; 				
					
					НомерСтроки = НомерСтроки + 1;
					
				КонецЦикла; 
				
			КонецЦикла;  	
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры  

&НаСервере
Процедура ЗагрузитьДанныеНаСервере()
	
	Для каждого СтрокаПродукта Из Объект.СписокПродуктов Цикл
		
		МассивПоказателей = Объект.ХимСостав.НайтиСтроки(Новый Структура("Наименование", СтрокаПродукта.Наименование));
		
		Группа = ПолучитьГруппу(СтрокаПродукта.Группа, Объект.Родитель);
		
		ПродуктПитания = ПолучитьПродуктПоНаименованию(СтрокаПродукта.Наименование, Справочники.ИсточникиИнформации.USDA_NND, 
													Новый Структура("Наименование, Родитель, Калорийность, Белки, Жиры, Углеводы", СтрокаПродукта.Наименование, Группа,
													СтрокаПродукта.Калорийность, СтрокаПродукта.Белки, СтрокаПродукта.Жиры, СтрокаПродукта.Углеводы));			
		
		НаборЗаписей = РегистрыСведений.ХимическийСоставПродуктов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Продукт.Установить(ПродуктПитания);
		
		Запись 					= НаборЗаписей.Добавить();
		Запись.Продукт 			= ПродуктПитания;
		Запись.Нутриент			= Справочники.Нутриенты.Калорийность; 						
		Запись.Количество 		= СтрокаПродукта.Калорийность; 		
		
		Запись 					= НаборЗаписей.Добавить();
		Запись.Продукт 			= ПродуктПитания;
		Запись.Нутриент			= Справочники.Нутриенты.Белки; 						
		Запись.Количество 		= СтрокаПродукта.Белки;
		
		Запись 					= НаборЗаписей.Добавить();
		Запись.Продукт 			= ПродуктПитания;
		Запись.Нутриент			= Справочники.Нутриенты.Жиры; 						
		Запись.Количество 		= СтрокаПродукта.Жиры;
		
		Запись 					= НаборЗаписей.Добавить();
		Запись.Продукт 			= ПродуктПитания;
		Запись.Нутриент			= Справочники.Нутриенты.Углеводы; 						
		Запись.Количество 		= СтрокаПродукта.Углеводы;
		
		Для каждого СтрокаПоказателя Из МассивПоказателей Цикл
			
			Количество		= 0;
			МаксКоличество	= 0;
			Точность		= 0.2;
			Наименование	= СтрокаПоказателя.Нутриент;
			ТипНутриента	= СтрокаПоказателя.ТипНутриента;
			Показатель		= СтрокаПоказателя.Количество;
			Нутриент		= Неопределено;     
			
			Разделитель 	= ПоискСКонца(Наименование, ",");
			ЕдИзм			= СокрЛП(Прав(Наименование, СтрДлина(Наименование) - Разделитель));
			
			Разделитель 	= Найти(Наименование, ",");
			ИмяНутриента 	= СокрЛП(Лев(Наименование, Разделитель - 1));   			
			
			Если ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Прочее") Тогда
						
				Если Наименование = "Вода, г" Тогда
					Нутриент = Справочники.Нутриенты.Вода;							
				ИначеЕсли Наименование = "Волокна, г" Тогда 			
					Нутриент = Справочники.Нутриенты.ПищевыеВолокна;
				КонецЕсли;	
				
			ИначеЕсли ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Минералы") Тогда  				
				Нутриент = ПолучитьНутриентПоНаименванию(ИмяНутриента, Перечисления.ТипыНутриентов.Минералы);  				
			ИначеЕсли ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Витамины") Тогда
				
				Если Наименование = "C, аскорбиновая к-та, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминC; 			
				ИначеЕсли Наименование = "B1, тиамин, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB1;
				ИначеЕсли Наименование = "B2, рибофлавин, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB2; 					
				ИначеЕсли Наименование = "B3, ниацин, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB3; 				
				ИначеЕсли Наименование = "B6, пиридоксин, мг" Тогда	  	                    		
					Нутриент = Справочники.Нутриенты.ВитаминB6; 				
				ИначеЕсли Наименование = "B9, фолаты, мкг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB9; 			
				ИначеЕсли Наименование = "В12, кобаламин, мкг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB12;
				ИначеЕсли Наименование = "A, ретинол, мкг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминA; 					
				ИначеЕсли Наименование = "E, α-токоферол, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминE; 				
				ИначеЕсли Наименование = "D (D2+D3), мкг" Тогда	  	                    		
					Нутриент = Справочники.Нутриенты.ВитаминD;					
				ИначеЕсли Наименование = "K, филлохинон, мкг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминK; 					
				ИначеЕсли Наименование = "B5, пантотеновая к-та, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB5; 				
				ИначеЕсли Наименование = "В4, холин, мг" Тогда	  	                    		
					Нутриент = Справочники.Нутриенты.ВитаминB4; 					
				КонецЕсли;
				
			ИначеЕсли ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Жиры") Тогда
				
				Если Наименование = "Насыщенные,  г" Тогда
					Нутриент = Справочники.Нутриенты.НЖК;							
				ИначеЕсли Наименование = "Холестерин, мг" Тогда 			
					Нутриент = Справочники.Нутриенты.Холестерин;
				КонецЕсли;	
				
			ИначеЕсли ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Аминокислоты") Тогда				
				Нутриент = ПолучитьНутриентПоНаименванию(ИмяНутриента, Перечисления.ТипыНутриентов.Аминокислоты);				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Нутриент) Тогда 					
					
				МассивЧисел = омРаботаСПростымиТипами.ПолучитьВсеЧислаВСтроке(Показатель);
				Если МассивЧисел.Количество() = 1 Тогда
					Количество = МассивЧисел[0];
				ИначеЕсли МассивЧисел.Количество() > 1 Тогда 
					МинКоличество 	= МассивЧисел[0];	
					МаксКоличество 	= МассивЧисел[МассивЧисел.ВГраница()]; 				
				КонецЕсли; 						
				
				Если Найти(ВРег(ЕдИзм), "МКГ") > 0 Тогда
					Делитель = 1000000;	
				ИначеЕсли Найти(ВРег(ЕдИзм), "МГ") > 0 Тогда 				
					Делитель = 1000; 				
				Иначе
					Делитель = 1;
				КонецЕсли;  								 
					
				Если Количество > 0 Тогда  						
					
					Значение = Количество / Делитель;
					
					Запись 					= НаборЗаписей.Добавить();
					Запись.Продукт 			= ПродуктПитания;
					Запись.Нутриент			= Нутриент; 						
					Запись.Количество 		= Значение;
					Запись.МинКоличество 	= Значение * (1 - Точность);	
					Запись.МаксКоличество 	= Мин(Значение * (1 + Точность), 100);
					
				КонецЕсли;
				
				Если МаксКоличество > 0 Тогда
					
					Запись 					= НаборЗаписей.Добавить();
					Запись.Продукт 			= ПродуктПитания;
					Запись.Нутриент			= Нутриент;  						   							
					Запись.МинКоличество 	= МинКоличество / Делитель;	
					Запись.МаксКоличество 	= МаксКоличество / Делитель;
					Запись.Количество		= ((МинКоличество + МаксКоличество) / 2) / Делитель; 
					
				КонецЕсли;  				
				
			КонецЕсли;			
			
		КонецЦикла; 
		
		НаборЗаписей.Записать();
		
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьНачалоВыбораФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ДиалогВыбораФайла = ДополнительныеПараметры.ДиалогВыбораФайла;  	
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда   		
		ВыбФайл = Новый Файл(ДиалогВыбораФайла.ПолноеИмяФайла);
		ВыбФайл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПроверкаСуществованияФайлаЗавершение", ЭтотОбъект, Новый Структура("ДиалогВыбораФайла", ДиалогВыбораФайла)));
		Возврат;
	КонецЕсли;		

КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСуществованияФайлаЗавершение(Существует, ДополнительныеПараметры) Экспорт
	
	ДиалогВыбораФайла = ДополнительныеПараметры.ДиалогВыбораФайла;  	
	
	Если Существует Тогда
		Объект.Путь = ДиалогВыбораФайла.ПолноеИмяФайла;	
		ПолучитьДанныеИзФайлаЭксель();
	КонецЕсли; 	

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеИзФайлаЭксель() 	
	
	Попытка
		Эксель = Новый COMОбъект("Excel.Application");		
		Эксель.DisplayAlerts = 0; 
		Эксель.Visible = 0; 		
	Исключение   		
		
		Эксель = Неопределено;   					
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки() + Символы.ПС +
		"Ошибка загрузки файла. "
		+ Символы.ВК + "Возможные причины:"  					 
		+ Символы.ВК + "1. На компьютере не установлен MS Excel;"
		+ Символы.ВК + "2. Выбранный файл поврежден;";
		Сообщение.Сообщить(); 
		
	КонецПопытки;
	
	Если Эксель <> Неопределено Тогда 	
		Книга = Эксель.WorkBooks.Open(Объект.Путь);		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагруритьНормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Попытка
			ЛистЭксель = Книга.Sheets(ИмяЛиста(1));	
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить();
		КонецПопытки;
		
		КоличествоКолонок 		= ЛистЭксель.Cells(1,1).SpecialCells(11).Column;
	    КоличествоСтрок 		= ЛистЭксель.Cells(1,1).SpecialCells(11).Row;
		
		Область = ЛистЭксель.Range(ЛистЭксель.Cells(1,1), ЛистЭксель.Cells(КоличествоСтрок, 3));
		
		Если Область.Value <> Неопределено Тогда
			
			ДанныеЭксель 			 = Область.Value.Выгрузить();		
			НомерСтроки 			 = 3;
			СоответствиеНутриентов 	 = Новый Соответствие;
			ДанныеПродукта			 = Новый Структура;  			
			ТипНутриента 			 = Неопределено;
			УИД 				     = Строка(Результат.УникальныйИдентификатор());
			
			Объект.СписокПродуктов.Очистить();
			НоваяНорма 				= Объект.СписокПродуктов.Добавить();
			НоваяНорма.Наименование = УИД;
			
			Пока НомерСтроки < КоличествоСтрок И ЗначениеЗаполнено(ДанныеЭксель[0][НомерСтроки]) Цикл 				
				
				ТребуетсяОбработкаСтроки 	= Истина;
				Наименование 				= СокрЛП(ДанныеЭксель[0][НомерСтроки]);
				МинКолво	 				= СокрЛП(ДанныеЭксель[1][НомерСтроки]);
				МаксКолво	 				= СокрЛП(ДанныеЭксель[2][НомерСтроки]);  
				Количество					= ?(ЗначениеЗаполнено(МаксКолво), МинКолво + ";" + МаксКолво, МинКолво);
								
				Если Наименование = "Общие" Тогда
					ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Прочее");	
					ТребуетсяОбработкаСтроки = Ложь;
				ИначеЕсли Наименование = "Минералы" Тогда 
					ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Минералы");
					ТребуетсяОбработкаСтроки = Ложь;  
				ИначеЕсли Наименование = "Витамины" Тогда
					ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Витамины");
					ТребуетсяОбработкаСтроки = Ложь;  
				ИначеЕсли Наименование = "Жирные кислоты" Тогда
					ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Жиры");
					ТребуетсяОбработкаСтроки = Ложь;  
				ИначеЕсли Наименование = "Аминокислоты" Тогда
					ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Аминокислоты");
					ТребуетсяОбработкаСтроки = Ложь; 
				КонецЕсли; 	
				
				Если Не ЗначениеЗаполнено(Количество) Тогда
					ТребуетсяОбработкаСтроки = Ложь;	
				КонецЕсли;
				
				Если ТребуетсяОбработкаСтроки Тогда 				 
				
					Если ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Прочее") Тогда
						
						Если Наименование = "Вода, г" Тогда
							ДобавитьЭлементХимСостава(УИД, Наименование, Количество, ТипНутриента);	
						ИначеЕсли Наименование = "Энергия, кКал" Тогда 
							НоваяНорма.Калорийность = МинКолво + ";" + МаксКолво;	
						ИначеЕсли Наименование = "Белки, г" Тогда 
							НоваяНорма.Белки = МинКолво + ";" + МаксКолво;
						ИначеЕсли Наименование = "Жиры, г" Тогда 
							НоваяНорма.Жиры = МинКолво + ";" + МаксКолво;
						ИначеЕсли Наименование = "Углеводы, г" Тогда
							НоваяНорма.Углеводы = МинКолво + ";" + МаксКолво;
						ИначеЕсли Наименование = "Волокна, г" Тогда 			
							ДобавитьЭлементХимСостава(УИД, Наименование, Количество, ТипНутриента);
						КонецЕсли;	
						
					Иначе
						ДобавитьЭлементХимСостава(УИД, Наименование, Количество, ТипНутриента);					
					КонецЕсли; 
				
				КонецЕсли; 				
				
				НомерСтроки = НомерСтроки + 1;
				
			КонецЦикла; 
			
			ЗагрузитьДанныеПоНорме();
			
		КонецЕсли;		
		
	КонецЕсли;   	

КонецПроцедуры 

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если Эксель <> Неопределено Тогда 		
		Эксель.Quit(); 		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеПоНорме()
	
	Для каждого СтрокаНормы Из Объект.СписокПродуктов Цикл
		
		МассивПоказателей = Объект.ХимСостав.НайтиСтроки(Новый Структура("Наименование", СтрокаНормы.Наименование));
		
		НормаОбъект = Справочники.НормыНутриентов.ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаНормы.Наименование)).ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(НормаОбъект, СтрокаНормы,, "Наименование");
		НормаОбъект.Записать();
		
		НаборЗаписей = РегистрыСведений.НормыПитания.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Норма.Установить(НормаОбъект.Ссылка); 
		
		Запись 					= НаборЗаписей.Добавить();
		Запись.Норма 			= НормаОбъект.Ссылка;
		Запись.Нутриент			= Справочники.Нутриенты.Калорийность; 						
		Запись.Количество 		= СтрокаНормы.Калорийность; 		
		
		Запись 					= НаборЗаписей.Добавить();
		Запись.Норма 			= НормаОбъект.Ссылка;
		Запись.Нутриент			= Справочники.Нутриенты.Белки; 						
		Запись.Количество 		= СтрокаНормы.Белки;
		
		Запись 					= НаборЗаписей.Добавить();
		Запись.Норма 			= НормаОбъект.Ссылка;
		Запись.Нутриент			= Справочники.Нутриенты.Жиры; 						
		Запись.Количество 		= СтрокаНормы.Жиры;
		
		Запись 					= НаборЗаписей.Добавить();
		Запись.Норма 			= НормаОбъект.Ссылка;
		Запись.Нутриент			= Справочники.Нутриенты.Углеводы; 						
		Запись.Количество 		= СтрокаНормы.Углеводы;
		
		Для каждого СтрокаПоказателя Из МассивПоказателей Цикл
			
			Количество		= 0;
			МаксКоличество	= 0;
			Точность		= 0.2;
			Наименование	= СтрокаПоказателя.Нутриент;
			ТипНутриента	= СтрокаПоказателя.ТипНутриента;
			Показатель		= СтрокаПоказателя.Количество;
			Нутриент		= Неопределено;     
			
			Разделитель 	= ПоискСКонца(Наименование, ",");
			ЕдИзм			= СокрЛП(Прав(Наименование, СтрДлина(Наименование) - Разделитель));
			
			Разделитель 	= Найти(Наименование, ",");
			ИмяНутриента 	= СокрЛП(Лев(Наименование, Разделитель - 1));   			
			
			Если ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Прочее") Тогда
						
				Если Наименование = "Вода, г" Тогда
					Нутриент = Справочники.Нутриенты.Вода;							
				ИначеЕсли Наименование = "Волокна, г" Тогда 			
					Нутриент = Справочники.Нутриенты.ПищевыеВолокна;
				КонецЕсли;	
				
			ИначеЕсли ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Минералы") Тогда  				
				Нутриент = ПолучитьНутриентПоНаименванию(ИмяНутриента, Перечисления.ТипыНутриентов.Минералы);  				
			ИначеЕсли ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Витамины") Тогда
				
				Если Наименование = "C, аскорбиновая к-та, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминC; 			
				ИначеЕсли Наименование = "B1, тиамин, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB1;
				ИначеЕсли Наименование = "B2, рибофлавин, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB2; 					
				ИначеЕсли Наименование = "B3, ниацин, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB3; 				
				ИначеЕсли Наименование = "B6, пиридоксин, мг" Тогда	  	                    		
					Нутриент = Справочники.Нутриенты.ВитаминB6; 				
				ИначеЕсли Наименование = "B9, фолаты, мкг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB9; 			
				ИначеЕсли Наименование = "В12, кобаламин, мкг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB12;
				ИначеЕсли Наименование = "A, ретинол, мкг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминA; 					
				ИначеЕсли Наименование = "E, α-токоферол, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминE; 				
				ИначеЕсли Наименование = "D (D2+D3), мкг" Тогда	  	                    		
					Нутриент = Справочники.Нутриенты.ВитаминD;					
				ИначеЕсли Наименование = "K, филлохинон, мкг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминK; 					
				ИначеЕсли Наименование = "B5, пантотеновая к-та, мг" Тогда 	
					Нутриент = Справочники.Нутриенты.ВитаминB5; 				
				ИначеЕсли Наименование = "В4, холин, мг" Тогда	  	                    		
					Нутриент = Справочники.Нутриенты.ВитаминB4; 					
				КонецЕсли;
				
			ИначеЕсли ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Жиры") Тогда
				
				Если Наименование = "Насыщенные,  г" Тогда
					Нутриент = Справочники.Нутриенты.НЖК;							
				ИначеЕсли Наименование = "Холестерин, мг" Тогда 			
					Нутриент = Справочники.Нутриенты.Холестерин;
				КонецЕсли;	
				
			ИначеЕсли ТипНутриента = ПредопределенноеЗначение("Перечисление.ТипыНутриентов.Аминокислоты") Тогда				
				Нутриент = ПолучитьНутриентПоНаименванию(ИмяНутриента, Перечисления.ТипыНутриентов.Аминокислоты);				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Нутриент) Тогда 					
					
				МассивЧисел = омРаботаСПростымиТипами.ПолучитьВсеЧислаВСтроке(Показатель);
				Если МассивЧисел.Количество() = 1 Тогда
					Количество = МассивЧисел[0];
				ИначеЕсли МассивЧисел.Количество() > 1 Тогда 
					МинКоличество 	= МассивЧисел[0];	
					МаксКоличество 	= МассивЧисел[МассивЧисел.ВГраница()]; 				
				КонецЕсли; 						
				
				Если Найти(ВРег(ЕдИзм), "МКГ") > 0 Тогда
					Делитель = 1000000;	
				ИначеЕсли Найти(ВРег(ЕдИзм), "МГ") > 0 Тогда 				
					Делитель = 1000; 				
				Иначе
					Делитель = 1;
				КонецЕсли;  								 
					
				Если Количество > 0 Тогда  						
					
					Значение = Количество / Делитель;
					
					Запись 					= НаборЗаписей.Добавить();
					Запись.Норма 			= НормаОбъект.Ссылка;
					Запись.Нутриент			= Нутриент; 						
					Запись.Количество 		= Значение;
					Запись.МинКоличество 	= Значение * (1 - Точность);	
					Запись.МаксКоличество 	= Мин(Значение * (1 + Точность), 100);
					
				КонецЕсли;
				
				Если МаксКоличество > 0 Тогда
					
					Запись 					= НаборЗаписей.Добавить();
					Запись.Норма 			= НормаОбъект.Ссылка;
					Запись.Нутриент			= Нутриент;  						   							
					Запись.МинКоличество 	= МинКоличество / Делитель;	
					Запись.МаксКоличество 	= МаксКоличество / Делитель;
					Запись.Количество		= ((МинКоличество + МаксКоличество) / 2) / Делитель; 
					
				КонецЕсли;  				
				
			КонецЕсли;			
			
		КонецЦикла; 
		
		НаборЗаписей.Записать();
		
	КонецЦикла; 
	
КонецПроцедуры

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
Функция ПолучитьПродуктПоНаименованию(Наименование, Источник, ДанныеЗаполнения)  		
	
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
		
		НовыйПродуктПитания 				= Результат.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(НовыйПродуктПитания, ДанныеЗаполнения); 			
		НовыйПродуктПитания.Записать();
		
	Иначе
		НовыйПродуктПитания 				= Справочники.ПродуктыПитания.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НовыйПродуктПитания, ДанныеЗаполнения); 		 	
		НовыйПродуктПитания.Источник		= Источник;		
		НовыйПродуктПитания.Записать();
		
		Результат = НовыйПродуктПитания.Ссылка; 
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьГруппу(Наименование, Родитель)
	
	Результат = Родитель; 	
			
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПродуктыПитания.Ссылка
		|ИЗ
		|	Справочник.ПродуктыПитания КАК ПродуктыПитания
		|ГДЕ
		|	ПродуктыПитания.ЭтоГруппа
		|	И ПродуктыПитания.Наименование = &Наименование
		|	И ПродуктыПитания.Ссылка В ИЕРАРХИИ(&Родитель)";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.УстановитьПараметр("Родитель", Родитель);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат = ВыборкаДетальныеЗаписи.Ссылка;
	Иначе
		ГруппаОбъект 				= Справочники.ПродуктыПитания.СоздатьГруппу();
		ГруппаОбъект.Родитель 		= Родитель;
		ГруппаОбъект.Наименование 	= Наименование;
		ГруппаОбъект.Записать();
		
		Результат  = ГруппаОбъект.Ссылка;
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции
 

&НаСервереБезКонтекста
Функция ПоискСКонца(ИсходнаяСтрока, Искомое) Экспорт

	ДлинаОбъекта  = СтрДлина(ИсходнаяСтрока);
	ДлинаИскомого = СтрДлина(Искомое);
	Для Сч = 0 По ДлинаОбъекта Цикл  		
		Если Сред(ИсходнаяСтрока, ДлинаОбъекта - Сч, ДлинаИскомого) = Искомое Тогда  			
			Возврат  ДлинаОбъекта - Сч - ДлинаИскомого + 1;
		КонецЕсли; 	 	
	КонецЦикла; 
	
	Возврат -1;

КонецФункции  

&НаКлиенте
Процедура ДобавитьЭлементХимСостава(УИД, Нутриент, Количество, ТипНутриента)
	
	НоваяСтрока 				= Объект.ХимСостав.Добавить();
	НоваяСтрока.Нутриент 		= Нутриент;	
	НоваяСтрока.Количество 		= Количество;
	НоваяСтрока.ТипНутриента 	= ТипНутриента;
	НоваяСтрока.Наименование 	= УИД;
	
КонецПроцедуры


