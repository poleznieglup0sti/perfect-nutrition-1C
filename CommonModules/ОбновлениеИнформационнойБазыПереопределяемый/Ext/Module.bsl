﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается перед обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Вызывается после завершении обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсияИБ     - Строка - версия ИБ до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ        - Строка - версия ИБ после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков
//                                             обновления, сгруппированных по номеру версии.
//  Для перебора выполненных обработчиков:
//		Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//	
//			Если Версия.Версия = "*" Тогда
//				группа обработчиков, которые выполняются всегда
//			Иначе
//				группа обработчиков, которые выполняются для определенной версии 
//			КонецЕсли;
//	
//			Для Каждого Обработчик Из Версия.Строки Цикл
//				...
//			КонецЦикла;
//	
//		КонецЦикла;
//
//   ВыводитьОписаниеОбновлений - Булево -	если Истина, то выводить форму с описанием 
//											обновлений.
//   МонопольныйРежим           - Булево - признак выполнения обновления в монопольном режиме.
//                                Истина - обновление выполнялось в монопольном режиме.
// 
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ,
	Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений программы.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновлений.
//   
// См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Вызывается для получения списка обработчиков обновления, которые не нужно выполнять.
// Отключать можно только обработчики обновления с номером версии "*".
//
// Пример добавления отключаемого обработчика в список:
//   НовоеИсключение = ОтключаемыеОбработчики.Добавить();
//   НовоеИсключение.ИдентификаторБиблиотеки = "СтандартныеПодсистемы";
//   НовоеИсключение.Версия = "*";
//   НовоеИсключение.Процедура = "ВариантыОтчетов.Обновить";
//
// Версия - номер версии конфигурации, в которой нужно отключить
//          выполнение обработчика.
//
Процедура ДобавитьОтключаемыеОбработчикиОбновления(ОтключаемыеОбработчики) Экспорт
	
КонецПроцедуры

// Переопределяет текст подсказки, указывающий путь к форме "Результаты обновления программы".
//
// Параметры:
//  ТекстПодсказки - Строка, текст подсказки.
//
Процедура ПолучитьТекстПоясненияДляРезультатовОбновленияПрограммы(ТекстПодсказки) Экспорт
	
КонецПроцедуры

// Устарела. Следует использовать процедуру ПриДобавленииПодсистем 
// общего модуля ПодсистемыКонфигурацииПереопределяемый.
//
// Вызывается перед началом обновления данных ИБ.
// Возвращает список процедур-обработчиков обновления ИБ для всех поддерживаемых версий ИБ.
//
// Пример добавления процедуры-обработчика в список:
//    Обработчик = Обработчики.Добавить();
//    Обработчик.Версия = "1.1.0.0";
//    Обработчик.Процедура = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//
// Возвращаемое значение:
//   ТаблицаЗначений - состав колонок см. в ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
Функция ОбработчикиОбновления() Экспорт
	
	Обработчики = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	
	// Подключаются процедуры-обработчики обновления конфигурации
	
	Возврат Обработчики;
	
КонецФункции

#КонецОбласти
