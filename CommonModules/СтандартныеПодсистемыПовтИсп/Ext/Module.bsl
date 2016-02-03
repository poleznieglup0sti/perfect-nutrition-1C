﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Содержит сохраненные параметры, используемые подсистемой.
Функция ПараметрыПрограммныхСобытий() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	СохраненныеПараметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
		"ПараметрыСлужебныхСобытий");
	УстановитьПривилегированныйРежим(Ложь);
	
	СтандартныеПодсистемыСервер.ПроверитьОбновлениеПараметровРаботыПрограммы(
		"ПараметрыСлужебныхСобытий",
		"ОбработчикиСобытий");
	
	Если НЕ СохраненныеПараметры.Свойство("ОбработчикиСобытий") Тогда
		СтандартныеПодсистемыВызовСервера.ПриОшибкеПолученияОбработчиковСобытия();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	СохраненныеПараметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
		"ПараметрыСлужебныхСобытий");
	УстановитьПривилегированныйРежим(Ложь);
	
	ПредставлениеПараметра = "";
	
	Если НЕ СохраненныеПараметры.Свойство("ОбработчикиСобытий") Тогда
		ПредставлениеПараметра = НСтр("ru = 'Обработчики событий'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеПараметра) Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка обновления информационной базы.
			           |Не заполнен параметр служебных событий:
			           |""%1"".'")
			+ СтандартныеПодсистемыСервер.УточнениеОшибкиПараметровРаботыПрограммыДляРазработчика(),
			ПредставлениеПараметра);
	КонецЕсли;
	
	Возврат СохраненныеПараметры;
	
КонецФункции

// Возвращает описания всех библиотек конфигурации, включая
// описание самой конфигурации.
//
Функция ОписанияПодсистем() Экспорт
	
	МодулиПодсистем = Новый Массив;
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБСП");
	
	
	ПодсистемыКонфигурацииПереопределяемый.ПриДобавленииПодсистем(МодулиПодсистем);
	
	ОписаниеКонфигурацииНайдено = Ложь;
	ОписанияПодсистем = Новый Структура;
	ОписанияПодсистем.Вставить("Порядок",  Новый Массив);
	ОписанияПодсистем.Вставить("ПоИменам", Новый Соответствие);
	
	ВсеТребуемыеПодсистемы = Новый Соответствие;
	
	Для каждого ИмяМодуля Из МодулиПодсистем Цикл
		
		Описание = НовоеОписаниеПодсистемы();
		Модуль = ОбщегоНазначения.ОбщийМодуль(ИмяМодуля);
		Модуль.ПриДобавленииПодсистемы(Описание);
		
		Если Описание.Имя = "СтандартныеПодсистемы" Тогда
			// <СВОЙСТВА ТОЛЬКО ДЛЯ БИБЛИОТЕКИ СТАНДАРТНЫХ ПОДСИСТЕМ>
			Описание.ДобавлятьСлужебныеСобытия            = Истина;
			Описание.ДобавлятьОбработчикиСлужебныхСобытий = Истина;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.Проверить(ОписанияПодсистем.ПоИменам.Получить(Описание.Имя) = Неопределено,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при подготовке описаний подсистем:
				           |в описании подсистемы (см. процедуру %1.ПриДобавленииПодсистемы)
				           |указано имя подсистемы ""%2"", которое уже зарегистрировано ранее.'"),
				ИмяМодуля, Описание.Имя));
		
		Если Описание.Имя = Метаданные.Имя Тогда
			ОписаниеКонфигурацииНайдено = Истина;
			Описание.Вставить("ЭтоКонфигурация", Истина);
		Иначе
			Описание.Вставить("ЭтоКонфигурация", Ложь);
		КонецЕсли;
		
		Описание.Вставить("ОсновнойСерверныйМодуль", ИмяМодуля);
		
		ОписанияПодсистем.ПоИменам.Вставить(Описание.Имя, Описание);
		// Настройка порядка подсистем с учетом порядка добавления основных модулей.
		ОписанияПодсистем.Порядок.Добавить(Описание.Имя);
		// Сборка всех требуемых подсистем.
		Для каждого ТребуемаяПодсистема Из Описание.ТребуемыеПодсистемы Цикл
			Если ВсеТребуемыеПодсистемы.Получить(ТребуемаяПодсистема) = Неопределено Тогда
				ВсеТребуемыеПодсистемы.Вставить(ТребуемаяПодсистема, Новый Массив);
			КонецЕсли;
			ВсеТребуемыеПодсистемы[ТребуемаяПодсистема].Добавить(Описание.Имя);
		КонецЦикла;
	КонецЦикла;
	
	// Проверка описания основной конфигурации.
	Если ОписаниеКонфигурацииНайдено Тогда
		Описание = ОписанияПодсистем.ПоИменам[Метаданные.Имя];
		
		ОбщегоНазначенияКлиентСервер.Проверить(Описание.Версия = Метаданные.Версия,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при подготовке описаний подсистем:
				           |версия ""%2"" конфигурации ""%1"" (см. процедуру %3.ПриДобавленииПодсистемы)
				           |не совпадает с версией конфигурации в метаданных ""%4"".'"),
				Описание.Имя,
				Описание.Версия,
				Описание.ОсновнойСерверныйМодуль,
				Метаданные.Версия));
	Иначе
		Описание = НовоеОписаниеПодсистемы();
		Описание.Вставить("Имя",    Метаданные.Имя);
		Описание.Вставить("Версия", Метаданные.Версия);
		Описание.Вставить("ЭтоКонфигурация", Истина);
		ОписанияПодсистем.ПоИменам.Вставить(Описание.Имя, Описание);
		ОписанияПодсистем.Порядок.Добавить(Описание.Имя);
	КонецЕсли;
	
	// Проверка наличия всех требуемых подсистем.
	Для каждого КлючИЗначение Из ВсеТребуемыеПодсистемы Цикл
		Если ОписанияПодсистем.ПоИменам.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
			ЗависимыеПодсистемы = "";
			Для каждого ЗависимаяПодсистема Из КлючИЗначение.Значение Цикл
				ЗависимыеПодсистемы = Символы.ПС + ЗависимаяПодсистема;
			КонецЦикла;
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при подготовке описаний подсистем:
				           |не найдена подсистема ""%1"" требуемая для подсистем: %2.'"),
				КлючИЗначение.Ключ,
				ЗависимыеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
	// Настройка порядка подсистем с учетом зависимостей.
	Для каждого КлючИЗначение Из ОписанияПодсистем.ПоИменам Цикл
		Имя = КлючИЗначение.Ключ;
		Порядок = ОписанияПодсистем.Порядок.Найти(Имя);
		Для каждого ТребуемаяПодсистема Из КлючИЗначение.Значение.ТребуемыеПодсистемы Цикл
			ПорядокТребуемойПодсистемы = ОписанияПодсистем.Порядок.Найти(ТребуемаяПодсистема);
			Если Порядок < ПорядокТребуемойПодсистемы Тогда
				Взаимозависимость = ОписанияПодсистем.ПоИменам[ТребуемаяПодсистема
					].ТребуемыеПодсистемы.Найти(Имя) <> Неопределено;
				Если Взаимозависимость Тогда
					НовыйПорядок = ПорядокТребуемойПодсистемы;
				Иначе
					НовыйПорядок = ПорядокТребуемойПодсистемы + 1;
				КонецЕсли;
				Если Порядок <> НовыйПорядок Тогда
					ОписанияПодсистем.Порядок.Вставить(НовыйПорядок, Имя);
					ОписанияПодсистем.Порядок.Удалить(Порядок);
					Порядок = НовыйПорядок - 1;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	// Смещение описания конфигурации в конец массива.
	Индекс = ОписанияПодсистем.Порядок.Найти(Метаданные.Имя);
	Если ОписанияПодсистем.Порядок.Количество() > Индекс + 1 Тогда
		ОписанияПодсистем.Порядок.Удалить(Индекс);
		ОписанияПодсистем.Порядок.Добавить(Метаданные.Имя);
	КонецЕсли;
	
	Для каждого КлючИЗначение Из ОписанияПодсистем.ПоИменам Цикл
		
		КлючИЗначение.Значение.ТребуемыеПодсистемы =
			Новый ФиксированныйМассив(КлючИЗначение.Значение.ТребуемыеПодсистемы);
		
		ОписанияПодсистем.ПоИменам[КлючИЗначение.Ключ] =
			Новый ФиксированнаяСтруктура(КлючИЗначение.Значение);
	КонецЦикла;
	
	ОписанияПодсистем.Порядок  = Новый ФиксированныйМассив(ОписанияПодсистем.Порядок);
	ОписанияПодсистем.ПоИменам = Новый ФиксированноеСоответствие(ОписанияПодсистем.ПоИменам);
	
	Возврат Новый ФиксированнаяСтруктура(ОписанияПодсистем);
	
КонецФункции

// Возвращает массив описаний обработчиков серверного события.
Функция ОбработчикиСерверногоСобытия(Событие, Служебное = Ложь) Экспорт
	
	ПодготовленныеОбработчики = ПодготовленныеОбработчикиСерверногоСобытия(Событие, Служебное);
	
	Если ПодготовленныеОбработчики = Неопределено Тогда
		// Автообновление кэша. Обновление повторно используемых значений требуется.
		СтандартныеПодсистемыВызовСервера.ПриОшибкеПолученияОбработчиковСобытия();
		ОбновитьПовторноИспользуемыеЗначения();
		// Повторная попытка получить обработчики события.
		ПодготовленныеОбработчики = ПодготовленныеОбработчикиСерверногоСобытия(Событие, Служебное, Ложь);
	КонецЕсли;
	
	Возврат ПодготовленныеОбработчики;
	
КонецФункции

// Возвращает соответствие имен "функциональных" подсистем и значения Истина.
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
Функция ИменаПодсистем() Экспорт
	
	Имена = Новый Соответствие;
	ВставитьИменаПодчиненныхПодсистем(Имена, Метаданные);
	
	Возврат Новый ФиксированноеСоответствие(Имена);
	
КонецФункции

// Возвращает список объектов метаданных, которые используются в РИБ
// только в момент создания начального образа подчиненного узла.
// Список объектов получается для всех подсистем, для которых определено событие
// "СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииОбъектовНачальногоОбразаПланаОбмена"
//
//  Возвращаемое значение:
// Тип: ФиксированноеСоответствие. Ключ - объект метаданных; Значение - Истина.
//
Функция ОбъектыНачальногоОбраза() Экспорт
	
	Результат = Новый Соответствие;
	
	Объекты = Новый Массив;
	
	// Получаем объекты начального образа
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииОбъектовНачальногоОбразаПланаОбмена");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПриПолученииОбъектовНачальногоОбразаПланаОбмена(Объекты);
		
	КонецЦикла;
	
	Для Каждого Объект Из Объекты Цикл
		
		Результат.Вставить(Объект.ПолноеИмя(), Истина);
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

// Возвращает список планов обмена РИБ.
// Если конфигурация работает в модели сервиса,
// то возвращает список разделенных планов обмена РИБ.
//
Функция ПланыОбменаРИБ() Экспорт
	
	Результат = Новый Массив;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
			
			Если ПланОбмена.РаспределеннаяИнформационнаяБаза
				И ОбщегоНазначенияПовтИсп.ЭтоРазделенныйОбъектМетаданных(ПланОбмена.ПолноеИмя(),
					ОбщегоНазначенияПовтИсп.РазделительОсновныхДанных())
				Тогда
				
				Результат.Добавить(ПланОбмена.Имя);
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
			
			Если ПланОбмена.РаспределеннаяИнформационнаяБаза Тогда
				
				Результат.Добавить(ПланОбмена.Имя);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает соответствие имен предопределенных значений ссылкам на них.
//
// Параметры:
//  ПолноеИмяОбъектаМетаданных - Строка, например, "Справочник.ВидыНоменклатуры",
//                               Поддерживаются только таблицы
//                               с предопределенными элементами:
//                               - Справочники,
//                               - Планы видов характеристик,
//                               - Планы счетов,
//                               - Планы видов расчета.
// 
// Возвращаемое значение:
//  Соответствие, где
//   Ключ     - Строка - имя предопределенного,
//   Значение - Ссылка предопределенного.
//
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТекущаяТаблица.Ссылка КАК Ссылка,
	|	ТекущаяТаблица.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	|ИЗ
	|	&ТекущаяТаблица КАК ТекущаяТаблица
	|ГДЕ
	|	ТекущаяТаблица.Предопределенный = ИСТИНА";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекущаяТаблица", ПолноеИмяОбъектаМетаданных);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПредопределенныеЗначения = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		ИмяПредопределенного = Выборка.ИмяПредопределенныхДанных;
		ПредопределенныеЗначения.Вставить(ИмяПредопределенного, Выборка.Ссылка);
	КонецЦикла;
	
	Возврат ПредопределенныеЗначения;
	
КонецФункции

// Возвращает Истина, если привилегированный режим был установлен
// при запуске с помощью параметра UsePrivilegedMode.
//
// Поддерживается только при запуске клиентских приложений
// (внешнее соединение не поддерживается).
//
Функция ПривилегированныйРежимУстановленПриЗапуске() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить(
		"ПривилегированныйРежимУстановленПриЗапуске") = Истина;
	
КонецФункции

// Только для внутреннего использования.
Функция ПараметрыРаботыПрограммы(ИмяКонстанты) Экспорт
	
	Параметры = Константы[ИмяКонстанты].Получить().Получить();
	
	Если ТипЗнч(Параметры) <> Тип("Структура") Тогда
		Параметры = Новый Структура;
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Параметры);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Получение идентификатора по объекту метаданных и наоборот

// Только для внутреннего использования
Функция ИдентификаторОбъектаМетаданных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	СтандартныеПодсистемыПовтИсп.СправочникИдентификаторыОбъектовМетаданныхПроверкаИспользования(Истина);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПолноеИмя", ПолноеИмяОбъектаМетаданных);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Идентификаторы.Ссылка КАК Ссылка,
	|	Идентификаторы.КлючОбъектаМетаданных,
	|	Идентификаторы.ПолноеИмя
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовМетаданных КАК Идентификаторы
	|ГДЕ
	|	Идентификаторы.ПолноеИмя = &ПолноеИмя
	|	И НЕ Идентификаторы.ПометкаУдаления";
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	Если Выгрузка.Количество() = 0 Тогда
		// Если идентификатор не найден по полному имени, возможно что полное имя задано с ошибкой
		Если Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных) = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при выполнении функции ОбщегоНазначения.ИдентификаторОбъектаМетаданных().
				           |
				           |Объект метаданных не найден по полному имени:
				           |""%1"".'"),
				ПолноеИмяОбъектаМетаданных);
		КонецЕсли;
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при выполнении функции ОбщегоНазначения.ИдентификаторОбъектаМетаданных().
			           |
			           |Для объекта метаданных ""%1""
			           |не найден идентификатор
			           |в справочнике ""Идентификаторы объектов метаданных"".'")
			+ СтандартныеПодсистемыСервер.УточнениеОшибкиПараметровРаботыПрограммыДляРазработчика(),
			ПолноеИмяОбъектаМетаданных);
	ИначеЕсли Выгрузка.Количество() > 1 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при выполнении функции ОбщегоНазначения.ИдентификаторОбъектаМетаданных().
			           |
			           |Для объекта метаданных ""%1""
			           |найдено несколько идентификаторов
			           |в справочнике ""Идентификаторы объектов метаданных"".'")
			+ СтандартныеПодсистемыСервер.УточнениеОшибкиПараметровРаботыПрограммыДляРазработчика(),
			ПолноеИмяОбъектаМетаданных);
	КонецЕсли;
	
	// Проверка соответствия ключа объекта метаданных полному имени объекта метаданных
	РезультатПроверки = Справочники.ИдентификаторыОбъектовМетаданных.КлючОбъектаМетаданныхСоответствуетПолномуИмени(Выгрузка[0]);
	Если РезультатПроверки.НеСоответствует Тогда
		Если РезультатПроверки.ОбъектМетаданных = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при выполнении функции ОбщегоНазначения.ИдентификаторОбъектаМетаданных().
				           |
				           |Для объекта метаданных ""%1""
				           |найден идентификатор в справочнике ""Идентификаторы объектов метаданных"",
				           |которому соответствует удаленный объект метаданных.'")
			+ СтандартныеПодсистемыСервер.УточнениеОшибкиПараметровРаботыПрограммыДляРазработчика(),
				ПолноеИмяОбъектаМетаданных);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при выполнении функции ОбщегоНазначения.ИдентификаторОбъектаМетаданных().
				           |
				           |Для объекта метаданных ""%1""
				           |найден идентификатор в справочнике ""Идентификаторы объектов метаданных"",
				           |который соответствует другому объекту метаданных ""%2"".'")
			+ СтандартныеПодсистемыСервер.УточнениеОшибкиПараметровРаботыПрограммыДляРазработчика(),
				ПолноеИмяОбъектаМетаданных,
				РезультатПроверки.ОбъектМетаданных);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Выгрузка[0].Ссылка;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Использование справочника ИдентификаторыОбъектовМетаданных

// Только для внутреннего использования.
Функция ОтключитьСправочникИдентификаторыОбъектовМетаданных() Экспорт
	
	Использовать = НЕ ОбщегоНазначения.ОбщиеПараметрыБазовойФункциональности(
		).ОтключитьСправочникИдентификаторыОбъектовМетаданных;
	
	Если Использовать Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов")
	 ИЛИ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки")
	 ИЛИ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов")
	 ИЛИ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		
		ВызватьИсключение
			НСтр("ru = 'Невозможно отключить справочник Идентификаторы объектов метаданных,
			           |если используется любая из следующих подсистем:
			           |- ВариантыОтчетов,
			           |- ДополнительныеОтчетыИОбработки,
			           |- РассылкаОтчетов,
			           |- УправлениеДоступом.'");
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Функция СправочникИдентификаторыОбъектовМетаданныхПроверкаИспользования(ПроверитьОбновление = Ложь) Экспорт
	
	Справочники.ИдентификаторыОбъектовМетаданных.ПроверкаИспользования();
	
	Если ПроверитьОбновление Тогда
		Справочники.ИдентификаторыОбъектовМетаданных.ДанныеОбновлены(Истина);
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для обновления справочника ИдентификаторыОбъектовМетаданных

// Только для внутреннего использования.
Функция ТаблицаПереименованияДляТекущейВерсии() Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.ТаблицаПереименованияДляТекущейВерсии();
	
КонецФункции

// Только для внутреннего использования.
Функция СвойстваКоллекцийОбъектовМетаданных() Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.СвойстваКоллекцийОбъектовМетаданных();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с предопределенными данными

// Получает ссылку предопределенного элемента по его полному имени.
//  Подробнее - см. ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент();
//
Функция ПредопределенныйЭлемент(Знач ПолноеИмяПредопределенного) Экспорт
	
	ИмяПредопределенного = ВРег(ПолноеИмяПредопределенного);
	
	Точка = Найти(ИмяПредопределенного, ".");
	ИмяКоллекции = Лев(ИмяПредопределенного, Точка - 1);
	ИмяПредопределенного = Сред(ИмяПредопределенного, Точка + 1);
	
	Точка = Найти(ИмяПредопределенного, ".");
	ИмяТаблицы = Лев(ИмяПредопределенного, Точка - 1);
	ИмяПредопределенного = Сред(ИмяПредопределенного, Точка + 1);
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1 Ссылка ИЗ &ПолноеИмяТаблицы ГДЕ ИмяПредопределенныхДанных = &ИмяПредопределенного";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолноеИмяТаблицы", ИмяКоллекции + "." + ИмяТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИмяПредопределенного", ИмяПредопределенного);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Возврат Результат.Выгрузить()[0].Ссылка;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НовоеОписаниеПодсистемы()
	
	Описание = Новый Структура;
	Описание.Вставить("Имя",    "");
	Описание.Вставить("Версия", "");
	Описание.Вставить("ТребуемыеПодсистемы", Новый Массив);
	
	// Свойство устанавливается автоматически.
	Описание.Вставить("ЭтоКонфигурация", Ложь);
	
	// Имя основного модуля библиотеки.
	// Может быть пустым для конфигурации.
	Описание.Вставить("ОсновнойСерверныйМодуль", "");
	
	//  <СВОЙСТВА ТОЛЬКО ДЛЯ БИБЛИОТЕКИ СТАНДАРТНЫХ ПОДСИСТЕМ>
	
	Описание.Вставить("ДобавлятьСобытия",            Ложь);
	Описание.Вставить("ДобавлятьОбработчикиСобытий", Ложь);
	
	//  ДобавлятьСлужебныеСобытия - Булево - если Истина, будет вызвана стандартная процедура
	//                         ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия)
	//                         из основного модуля библиотеки.
	// 
	//  ДобавлятьОбработчикиСлужебныхСобытий - Булево - если Истина, будет вызвана стандартная процедура
	//                         ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики)
	//                         из основного модуля библиотеки.
	
	Описание.Вставить("ДобавлятьСлужебныеСобытия",            Ложь);
	Описание.Вставить("ДобавлятьОбработчикиСлужебныхСобытий", Ложь);
	
	Возврат Описание;
	
КонецФункции

Процедура ВставитьИменаПодчиненныхПодсистем(Имена, РодительскаяПодсистема, Все = Ложь, ИмяРодительскойПодсистемы = "")
	
	Для каждого ТекущаяПодсистема Из РодительскаяПодсистема.Подсистемы Цикл
		
		Если ТекущаяПодсистема.ВключатьВКомандныйИнтерфейс И Не Все Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяТекущейПодсистемы = ИмяРодительскойПодсистемы + ТекущаяПодсистема.Имя;
		Имена.Вставить(ИмяТекущейПодсистемы, Истина);
		
		Если ТекущаяПодсистема.Подсистемы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ВставитьИменаПодчиненныхПодсистем(Имена, ТекущаяПодсистема, Все, ИмяТекущейПодсистемы + ".");
	КонецЦикла;
	
КонецПроцедуры

Функция ПодготовленныеОбработчикиСерверногоСобытия(Событие, Служебное = Ложь, ПерваяПопытка = Истина)
	
	Параметры = СтандартныеПодсистемыПовтИсп.ПараметрыПрограммныхСобытий(
		).ОбработчикиСобытий.НаСервере;
	
	Если Служебное Тогда
		Обработчики = Параметры.ОбработчикиСлужебныхСобытий.Получить(Событие);
	Иначе
		Обработчики = Параметры.ОбработчикиСобытий.Получить(Событие);
	КонецЕсли;
	
	Если ПерваяПопытка И Обработчики = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Обработчики = Неопределено Тогда
		Если Служебное Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдено серверное служебное событие ""%1"".'"), Событие);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдено серверное событие ""%1"".'"), Событие);
		КонецЕсли;
	КонецЕсли;
	
	Массив = Новый Массив;
	
	Для каждого Обработчик Из Обработчики Цикл
		Элемент = Новый Структура;
		Модуль = Неопределено;
		Если ПерваяПопытка Тогда
			Попытка
				Модуль = ОбщегоНазначения.ОбщийМодуль(Обработчик.Модуль);
			Исключение
				Возврат Неопределено;
			КонецПопытки;
		Иначе
			Модуль = ОбщегоНазначения.ОбщийМодуль(Обработчик.Модуль);
		КонецЕсли;
		Элемент.Вставить("Модуль",     Модуль);
		Элемент.Вставить("Версия",     Обработчик.Версия);
		Элемент.Вставить("Подсистема", Обработчик.Подсистема);
		Массив.Добавить(Новый ФиксированнаяСтруктура(Элемент));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Массив);
	
КонецФункции

#КонецОбласти
