﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ПродуктПитания", ПродуктПитания) ИЛИ НЕ ЗначениеЗаполнено(ПродуктПитания) ИЛИ ПродуктПитания.ЭтоГруппа Тогда
		Отказ = Истина;	
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		СформироватьДеревоНутриентов();	
		Заголовок = ПродуктПитания;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьХимическийСостав(Команда)
	СохранитьХимическийСоставНаСервере();
	Закрыть();
КонецПроцедуры  

&НаСервере
Процедура СформироватьДеревоНутриентов()   	
			
    ДанныеЗаполнения = ПолучитьДанныеДереваНутриентов();
	
	ЗаполнитьДеревоНутриентов(ДеревоНутриенты.ПолучитьЭлементы(), ДанныеЗаполнения.ТаблицаГрупп, ДанныеЗаполнения.ВыборкаЭлементов, 
									Новый Структура("Родитель", Справочники.Нутриенты.ПустаяСсылка()));
									
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеДереваНутриентов()
	
	Результат = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Нутриенты.Ссылка КАК Нутриент,
		|	Нутриенты.Родитель
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|ГДЕ
		|	Нутриенты.ЭтоГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Нутриенты.Ссылка КАК Нутриент,
		|	ЕСТЬNULL(ХимическийСоставПродуктов.Количество, 0) КАК Количество,
		|	ЕСТЬNULL(ХимическийСоставПродуктов.Количество, 0) КАК СтароеКоличество,
		|	Нутриенты.Тип КАК Тип,
		|	Нутриенты.Родитель КАК Родитель,
		|	Нутриенты.ЭтоГруппа КАК ЭтоГруппа
		|ИЗ
		|	Справочник.Нутриенты КАК Нутриенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ХимическийСоставПродуктов.Нутриент КАК Нутриент,
		|			ХимическийСоставПродуктов.Количество КАК Количество
		|		ИЗ
		|			РегистрСведений.ХимическийСоставПродуктов КАК ХимическийСоставПродуктов
		|		ГДЕ
		|			ХимическийСоставПродуктов.Продукт = &Продукт) КАК ХимическийСоставПродуктов
		|		ПО Нутриенты.Ссылка = ХимическийСоставПродуктов.Нутриент
		|ГДЕ
		|	НЕ Нутриенты.ЭтоГруппа";
	
	Запрос.УстановитьПараметр("Продукт", ПродуктПитания);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Результат.Вставить("ТаблицаГрупп", РезультатЗапроса[0].Выгрузить());
	Результат.Вставить("ВыборкаЭлементов", РезультатЗапроса[1].Выбрать());
	
	Возврат Результат;
	
КонецФункции  

&НаСервере 								
Процедура ЗаполнитьДеревоНутриентов(СтрокаДерева, ТаблицаГрупп, ВыборкаЭлементов, СтруктураПоиска)  	
		
	МассивСтрок = ТаблицаГрупп.НайтиСтроки(СтруктураПоиска); 
	Для каждого СтрокаТаблицы Из МассивСтрок Цикл
		
		НоваяГруппаДерева 					= СтрокаДерева.Добавить();
		НоваяГруппаДерева.Картинка 			= БиблиотекаКартинок.ЭлектронноеПисьмо;
		НоваяГруппаДерева.Нутриент 			= СтрокаТаблицы.Нутриент;
		НоваяГруппаДерева.ЭтоГруппа			= Истина;
		
		ЗаполнитьДеревоНутриентов(НоваяГруппаДерева.ПолучитьЭлементы(), ТаблицаГрупп, ВыборкаЭлементов,
										Новый Структура("Родитель", СтрокаТаблицы.Нутриент));
		
	КонецЦикла; 
							
	ВыборкаЭлементов.Сбросить();						
	
	Пока ВыборкаЭлементов.НайтиСледующий(СтруктураПоиска) Цикл
		
		НоваяСтрокаДерева 			= СтрокаДерева.Добавить();	
		НоваяСтрокаДерева.Картинка 	= БиблиотекаКартинок.Реквизит;
		ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, ВыборкаЭлементов);		 		
		
	КонецЦикла;
	
КонецПроцедуры								

&НаСервере
Процедура СохранитьХимическийСоставНаСервере()
	
	Набор = РегистрыСведений.ХимическийСоставПродуктов.СоздатьНаборЗаписей();
	Набор.Отбор.Продукт.Установить(ПродуктПитания);	
	
	ОбходДереваНутриентов(Набор, ДеревоНутриенты.ПолучитьЭлементы());	
	
	Если Набор.Количество() > 0 Тогда
		Набор.Записать(Истина);	
	КонецЕсли;   
	
КонецПроцедуры

&НаСервере
Процедура ОбходДереваНутриентов(Набор, СтрокиДерева)	
	 
	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Если СтрокаДерева.ЭтоГруппа Тогда
			ОбходДереваНутриентов(Набор, СтрокаДерева.ПолучитьЭлементы());	
		ИначеЕсли СтрокаДерева.Количество <> СтрокаДерева.СтароеКоличество Тогда 
			Запись 				= Набор.Добавить();
			Запись.Продукт  	= ПродуктПитания;
			Запись.Нутриент 	= СтрокаДерева.Нутриент;
			Запись.Количество 	= СтрокаДерева.Количество;
		КонецЕсли;
		
	КонецЦикла;  	
	
КонецПроцедуры
 


 
