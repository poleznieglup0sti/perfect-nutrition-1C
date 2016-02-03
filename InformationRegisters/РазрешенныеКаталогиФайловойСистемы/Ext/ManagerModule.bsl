﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает XDTO-тип, описывающий разрешения типа, соответствующего элементу кэша.
//
// Возвращаемое значение - ТипОбъектаXDTO.
//
Функция ТипXDTOПредставленияРазрешений() Экспорт
	
	Возврат ФабрикаXDTO.Тип(РаботаВБезопасномРежимеСлужебный.ПакетXDTOПредставленийРазрешений(), "FileSystemAccess");
	
КонецФункции

// Формирует набор записей текущего регистра кэша из XDTO-представлений разрешения.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка,
//  Владелец - ЛюбаяСсылка,
//  XDTOПредставления - Массив(ОбъектXDTO).
//
// Возвращаемое значение - РегистрСведенийНаборЗаписей.
//
Функция НаборЗаписейИзXDTOПредставления(Знач XDTOПредставления, Знач ВнешнийМодуль, Знач Владелец, Знач ДляУдаления) Экспорт
	
	Набор = СоздатьНаборЗаписей();
	
	СвойстваПрограммногоМодуля = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.СвойстваДляРегистраРазрешений(ВнешнийМодуль);
	Набор.Отбор.ТипПрограммногоМодуля.Установить(СвойстваПрограммногоМодуля.Тип);
	Набор.Отбор.ИдентификаторПрограммногоМодуля.Установить(СвойстваПрограммногоМодуля.Идентификатор);
	
	СвойстваВладельца = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.СвойстваДляРегистраРазрешений(Владелец);
	Набор.Отбор.ТипВладельца.Установить(СвойстваВладельца.Тип);
	Набор.Отбор.ИдентификаторВладельца.Установить(СвойстваВладельца.Идентификатор);
	
	Если ДляУдаления Тогда
		
		Возврат Набор;
		
	Иначе
		
		Таблица = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ТаблицаРазрешений(СоздатьНаборЗаписей().Метаданные(), Истина);
		
		Для Каждого XDTOПредставление Из XDTOПредставления Цикл
			
			Ключ = Новый Структура("ТипПрограммногоМодуля,ИдентификаторПрограммногоМодуля,ТипВладельца,ИдентификаторВладельца,Адрес",
				СвойстваПрограммногоМодуля.Тип, 
				СвойстваПрограммногоМодуля.Идентификатор, 
				СвойстваВладельца.Тип, 
				СвойстваВладельца.Идентификатор, 
				XDTOПредставление.Path);
			СтрокиПоКлючу = Таблица.НайтиСтроки(Ключ);
			
			Если СтрокиПоКлючу.Количество() = 0 Тогда
				Строка = Таблица.Добавить();
				Строка.ТипПрограммногоМодуля = СвойстваПрограммногоМодуля.Тип;
				Строка.ИдентификаторПрограммногоМодуля = СвойстваПрограммногоМодуля.Идентификатор;
				Строка.ТипВладельца = СвойстваВладельца.Тип;
				Строка.ИдентификаторВладельца = СвойстваВладельца.Идентификатор;
				Строка.Адрес = XDTOПредставление.Path;
				Строка.РазрешеноЧтениеДанных = XDTOПредставление.AllowedRead;
				Строка.РазрешенаЗаписьДанных = XDTOПредставление.AllowedWrite;
			ИначеЕсли СтрокиПоКлючу.Количество() = 1 Тогда
				Строка = СтрокиПоКлючу[0];
				Если XDTOПредставление.AllowedRead И Не Строка.РазрешеноЧтениеДанных Тогда
					Строка.РазрешеноЧтениеДанных = Истина;
				КонецЕсли;
				Если XDTOПредставление.AllowedWrite И Не Строка.РазрешенаЗаписьДанных Тогда
					Строка.РазрешенаЗаписьДанных = Истина;
				КонецЕсли;
			Иначе
			КонецЕсли;
			
		КонецЦикла;
		
		Набор.Загрузить(Таблица);
		Возврат Набор;
		
	КонецЕсли;
	
КонецФункции

// Заполняет описание профиля безопасности (в нотации программного интерфейса общего модуля
//  АдминистрированиеКластераКлиентСервер) по менеджеру записи текущего элемента кэша.
//
// Параметры:
//  Менеджер - РегистрСведенийМенеджерЗаписи,
//  Профиль - Структура.
//
Процедура ЗаполнитьСвойстваПрофиляБезопасностиВНотацииИнтерфейсаАдминистрирования(Знач Менеджер, Профиль) Экспорт
	
	Если СтандартныеВиртуальныеКаталоги().Получить(Менеджер.Адрес) <> Неопределено Тогда
		
		ВиртуальныйКаталог = АдминистрированиеКластераКлиентСервер.СвойстваВиртуальногоКаталога();
		ВиртуальныйКаталог.ЛогическийURL = Менеджер.Адрес;
		ВиртуальныйКаталог.ФизическийURL = СтандартныеВиртуальныеКаталоги().Получить(Менеджер.Адрес);
		ВиртуальныйКаталог.ЧтениеДанных = Менеджер.РазрешеноЧтениеДанных;
		ВиртуальныйКаталог.ЗаписьДанных = Менеджер.РазрешенаЗаписьДанных;
		Профиль.ВиртуальныеКаталоги.Добавить(ВиртуальныйКаталог);
		
	Иначе
		
		ВиртуальныйКаталог = АдминистрированиеКластераКлиентСервер.СвойстваВиртуальногоКаталога();
		ВиртуальныйКаталог.ЛогическийURL = Менеджер.Адрес;
		ВиртуальныйКаталог.ФизическийURL = Менеджер.Адрес;
		ВиртуальныйКаталог.ЧтениеДанных = Менеджер.РазрешеноЧтениеДанных;
		ВиртуальныйКаталог.ЗаписьДанных = Менеджер.РазрешенаЗаписьДанных;
		Профиль.ВиртуальныеКаталоги.Добавить(ВиртуальныйКаталог);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст запроса для получения текущего среза разрешений по данному
//  элементу кэша.
//
// Параметры:
//  СвернутьВладельцев - Булево - флаг необходимости сворачивания результата запроса
//    по владельцам.
//
// Возвращаемое значение - Строка, текст запроса.
//
Функция ЗапросТекущегоСреза(Знач СвернутьВладельцев = Истина) Экспорт
	
	Если СвернутьВладельцев Тогда
		
		Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
		        |	Разрешения.Адрес,
		        |	Разрешения.РазрешеноЧтениеДанных,
		        |	Разрешения.РазрешенаЗаписьДанных
		        |ИЗ
		        |	РегистрСведений.РазрешенныеКаталогиФайловойСистемы КАК Разрешения";
		
	Иначе
		
		Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
		        |	Разрешения.Адрес,
		        |	Разрешения.РазрешеноЧтениеДанных,
		        |	Разрешения.РазрешенаЗаписьДанных,
		        |	Разрешения.ТипПрограммногоМодуля КАК ТипПрограммногоМодуля,
		        |	Разрешения.ИдентификаторПрограммногоМодуля КАК ИдентификаторПрограммногоМодуля,
		        |	Разрешения.ТипВладельца КАК ТипВладельца,
		        |	Разрешения.ИдентификаторВладельца КАК ИдентификаторВладельца
		        |ИЗ
		        |	РегистрСведений.РазрешенныеКаталогиФайловойСистемы КАК Разрешения";
		
	КонецЕсли;
	
КонецФункции

// Возвращает текст запроса для получения дельты измения разрешений по данному
//  элементу кэша.
//
// Возвращаемое значение - Строка, текст запроса.
//
Функция ЗапросПолученияДельты() Экспорт
	
	Возврат
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_До.Адрес,
		|	ВТ_До.РазрешеноЧтениеДанных,
		|	ВТ_До.РазрешенаЗаписьДанных,
		|	ВТ_До.ТипПрограммногоМодуля,
		|	ВТ_До.ИдентификаторПрограммногоМодуля
		|ИЗ
		|	ВТ_До КАК ВТ_До
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_После КАК ВТ_После
		|		ПО ВТ_До.ТипПрограммногоМодуля = ВТ_После.ТипПрограммногоМодуля
		|			И ВТ_До.ИдентификаторПрограммногоМодуля = ВТ_После.ИдентификаторПрограммногоМодуля
		|			И ВТ_До.Адрес = ВТ_После.Адрес
		|ГДЕ
		|	ВТ_После.Адрес ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_После.Адрес,
		|	ВТ_После.РазрешеноЧтениеДанных,
		|	ВТ_После.РазрешенаЗаписьДанных,
		|	ВТ_После.ТипПрограммногоМодуля,
		|	ВТ_После.ИдентификаторПрограммногоМодуля
		|ИЗ
		|	ВТ_После КАК ВТ_После
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_До КАК ВТ_До
		|		ПО ВТ_После.ТипПрограммногоМодуля = ВТ_До.ТипПрограммногоМодуля
		|			И ВТ_После.ИдентификаторПрограммногоМодуля = ВТ_До.ИдентификаторПрограммногоМодуля
		|			И ВТ_После.Адрес = ВТ_До.Адрес
		|ГДЕ
		|	ВТ_До.Адрес ЕСТЬ NULL ";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтандартныеВиртуальныеКаталоги()
	
	Результат = Новый Соответствие();
	
	Результат.Вставить("/temp", "%t/%i/%s/%p");
	Результат.Вставить("/bin", "%e");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли