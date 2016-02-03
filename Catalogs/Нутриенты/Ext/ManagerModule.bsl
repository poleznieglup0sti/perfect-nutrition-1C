﻿#Область ПрограммныйИнтерфейс

Функция ПолучитьКоэффициентПересчетаМЕ_в_мкг(Нутриент) Экспорт
	
	Результат = 1;
	
	Если Нутриент = Справочники.Нутриенты.ВитаминD Тогда  		
		Результат = 0.0250;
	ИначеЕсли Нутриент = Справочники.Нутриенты.ВитаминE Тогда 
		Результат = 666.6667;
	ИначеЕсли Нутриент = Справочники.Нутриенты.ВитаминA Тогда 
		Результат = 0.3;
	ИначеЕсли Нутриент = Справочники.Нутриенты.ВитаминC Тогда 
		Результат = 50;
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьРеквизитыПредопределенныхНутриентов() Экспорт 	
			
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Нутриенты.Ссылка КАК Нутриент
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	Нутриенты.Ссылка В ИЕРАРХИИ(&Аминокислоты)
		|	И НЕ Нутриенты.ЭтоГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Нутриенты.Ссылка КАК Нутриент
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	Нутриенты.Ссылка В ИЕРАРХИИ(&Витамины)
		|	И НЕ Нутриенты.ЭтоГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Нутриенты.Ссылка КАК Нутриент
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	Нутриенты.Ссылка В ИЕРАРХИИ(&Жиры)
		|	И НЕ Нутриенты.ЭтоГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Нутриенты.Ссылка КАК Нутриент
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	Нутриенты.Ссылка В ИЕРАРХИИ(&МакроНутриенты)
		|	И НЕ Нутриенты.ЭтоГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Нутриенты.Ссылка КАК Нутриент
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	Нутриенты.Ссылка В ИЕРАРХИИ(&Минералы)
		|	И НЕ Нутриенты.ЭтоГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Нутриенты.Ссылка КАК Нутриент
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	Нутриенты.Ссылка В ИЕРАРХИИ(&Углеводы)
		|	И НЕ Нутриенты.ЭтоГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Нутриенты.Ссылка КАК Нутриент
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	Нутриенты.Родитель = ЗНАЧЕНИЕ(Справочник.Нутриенты.ПустаяСсылка)
		|	И НЕ Нутриенты.ЭтоГруппа";
	
	Запрос.УстановитьПараметр("Аминокислоты", Справочники.Нутриенты.Аминокислоты);
	Запрос.УстановитьПараметр("Витамины", Справочники.Нутриенты.Витамины);
	Запрос.УстановитьПараметр("Жиры", Справочники.Нутриенты.Жиры_);
	Запрос.УстановитьПараметр("МакроНутриенты", Справочники.Нутриенты.МакроНутриенты);
	Запрос.УстановитьПараметр("Минералы", Справочники.Нутриенты.Минералы);
	Запрос.УстановитьПараметр("Углеводы", Справочники.Нутриенты.Углеводы_); 
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	СоответствиеТиповИНутриентов = Новый Соответствие;
	СоответствиеТиповИНутриентов.Вставить(Перечисления.ТипыНутриентов.Аминокислоты, РезультатЗапроса[0].Выбрать());
	СоответствиеТиповИНутриентов.Вставить(Перечисления.ТипыНутриентов.Витамины, РезультатЗапроса[1].Выбрать());
	СоответствиеТиповИНутриентов.Вставить(Перечисления.ТипыНутриентов.Жиры, РезультатЗапроса[2].Выбрать());
	СоответствиеТиповИНутриентов.Вставить(Перечисления.ТипыНутриентов.МакроНутриенты, РезультатЗапроса[3].Выбрать());
	СоответствиеТиповИНутриентов.Вставить(Перечисления.ТипыНутриентов.Минералы, РезультатЗапроса[4].Выбрать());
	СоответствиеТиповИНутриентов.Вставить(Перечисления.ТипыНутриентов.Углеводы, РезультатЗапроса[5].Выбрать());  	
	СоответствиеТиповИНутриентов.Вставить(Перечисления.ТипыНутриентов.Прочее, РезультатЗапроса[6].Выбрать());
	
	Для каждого Ит Из СоответствиеТиповИНутриентов Цикл
		
		ВыборкаДетальныеЗаписи = Ит.Значение;
	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			НутриентОбъект 		= ВыборкаДетальныеЗаписи.Нутриент.ПолучитьОбъект();
			НутриентОбъект.Тип 	= Ит.Ключ;
			
			Если Ит.Ключ = Перечисления.ТипыНутриентов.Витамины Тогда
				
				Если ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB1 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;	
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB10 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;		
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB11 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;		
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB12 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;		
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB13 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;			
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB15 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;				
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB2 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;					
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB3 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;						
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB4 Тогда				
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;	
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB5 Тогда	
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;	
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB6 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB7 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;						
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB8 Тогда				
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминB9 Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминC Тогда  
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Водорастворимый;
					
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминA Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Жирорастворимый;						
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминD Тогда				
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Жирорастворимый;
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминE Тогда
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Жирорастворимый;
				ИначеЕсли ВыборкаДетальныеЗаписи.Нутриент = Справочники.Нутриенты.ВитаминK Тогда  
					НутриентОбъект.Растворимость = Перечисления.Растворимость.Жирорастворимый; 					
			
				КонецЕсли; 	
				
			ИначеЕсли Ит.Ключ = Перечисления.ТипыНутриентов.Минералы Тогда
				
				
				
			КонецЕсли; 
			
			НутриентОбъект.Записать();
			
		КонецЦикла;
		
	КонецЦикла; 		
		
КонецПроцедуры

#КонецОбласти

