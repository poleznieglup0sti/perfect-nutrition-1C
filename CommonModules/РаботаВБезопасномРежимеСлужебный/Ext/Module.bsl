﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Поддержка профилей безопасности
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Декларация программных событий
//

// Объявляет служебные события подсистемы БазоваяФункциональность, предназначенные
//  для поддержки профилей безопасности.
//
// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// СЕРВЕРНЫЕ СОБЫТИЯ.
	
	// Вызывается при проверке возможности использования профилей безопасности
	//
	// Параметры:
	//  Отказ - Булево. Если для информационной базы недоступно использование профилей безопасности -
	//    значение данного параметра нужно установить равным Истина.
	//
	// Синтаксис:
	// Процедура ПриПроверкеВозможностиИспользованияПрофилейБезопасности(Отказ) Экспорт
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПроверкеВозможностиИспользованияПрофилейБезопасности");
	
	// Вызывается при проверке возможности настройки профилей безопасности
	//
	// Параметры:
	//  Отказ - Булево. Если для информационной базы недоступно использование профилей безопасности -
	//    значение данного параметра нужно установить равным Истина.
	//
	// Синтаксис:
	// Процедура ПриПроверкеВозможностиНастройкиПрофилейБезопасности(Отказ) Экспорт
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПроверкеВозможностиНастройкиПрофилейБезопасности");
	
	// Вызывается при включении использования для информационной базы профилей безопасности.
	//
	// Синтаксис:
	// Процедура ПриВключенииИспользованияПрофилейБезопасности() Экспорт
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриВключенииИспользованияПрофилейБезопасности");
	
	// Заполняет перечень запросов внешних разрешений, которые обязательно должны быть предоставлены
	// при создании информационной базы или обновлении программы.
	//
	// Параметры:
	//  ЗапросыРазрешений - Массив - список запросов, возвращаемых функцией
	//                      ЗапросНаИспользованиеВнешнихРесурсов модуля РаботаВБезопасномРежиме.
	//
	// Синтаксис:
	// Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам");
	
	// Вызывается при регистрации менеджеров внешних модулей.
	//
	// Параметры:
	//  Менеджеры - Массив(ОбщийМодуль).
	//
	// Синтаксис:
	// Процедура ПриРегистрацииМенеджеровВнешнихМодулей(Менеджеры) Экспорт
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриРегистрацииМенеджеровВнешнихМодулей");
	
	// Вызывается при создании запроса на администрирование разрешений использования внешних ресурсов.
	//
	// Параметры:
	//  ВнешнийМодуль - ЛюбаяСсылка,
	//  Операция - ПеречислениеСсылка.ОперацииСНаборамиРазрешений,
	//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки создания запроса на администрирование
	//    использования внешних ресурсов.
	//  Результат - УникальныйИдентификатор - идентификатор запроса (в том случае, если внутри обработчика
	//    значение параметра СтандартнаяОбработка установлено в значение Ложь).
	//
	// Синтаксис:
	// Процедура ПриЗапросеНаАдминистрированиеРазрешенийИспользованияВнешнихРесурсов(Знач ВнешнийМодуль, Знач Операция, СтандартнаяОбработка, Результат) Экспорт
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриЗапросеНаАдминистрированиеРазрешенийИспользованияВнешнихРесурсов");
	
	// Вызывается при создании запроса на использование внешних ресурсов.
	//
	// Параметры:
	//  Владелец - ЛюбаяСсылка - владелец запрашиваемых разрешений на использование внешних ресурсов,
	//  РежимЗамещения - Булево - флаг замещения ранее предоставленных разрешений по владельцу,
	//  ДобавляемыеРазрешения - Массив(ОбъектXDTO) - массив добавляемых разрешений,
	//  УдаляемыеРазрешения - Массив(ОбъектXDTO) - массив удаляемых разрешений,
	//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки создания запроса на использование
	//    внешних ресурсов.
	//  Результат - УникальныйИдентификатор - идентификатор запроса (в том случае, если внутри обработчика
	//    значение параметра СтандартнаяОбработка установлено в значение Ложь).
	//
	// Синтаксис:
	// Процедура ПриЗапросеРазрешенийНаИспользованиеВнешнихРесурсов(Знач Владелец, Знач РежимЗамещения, Знач ДобавляемыеРазрешения = Неопределено, Знач УдаляемыеРазрешения = Неопределено, СтандартнаяОбработка, Результат) Экспорт
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриЗапросеРазрешенийНаИспользованиеВнешнихРесурсов");
	
	// Вызывается при расчете дельты изменений на использование внешних ресурсов.
	//
	// Параметры:
	//  ИдентификаторыЗапросов - Массив(УникальныйИдентификатор) - массив идентификаторов запросов,
	//    для которых рассчитывается дельта,
	//  РежимВосстановления - Булево, флаг расчета дельты в режиме восстановления разрешений в кластере
	//    серверов,
	//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки расчета дельты,
	//  Результат - ТаблицаЗначений - дельта изменений разрешений на использование внешних ресурсов
	//    (в том случае, если внутри обработчика значение параметра СтандартнаяОбработка установлено в значение Ложь).
	//
	// Синтаксис:
	// Процедура ПриРасчетеДельтыИзмененийНаИспользованиеВнешнихРесурсов(Знач ИдентификаторыЗапросов, Знач РежимВосстановления, СтандартнаяОбработка, Результат) Экспорт
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриРасчетеДельтыИзмененийНаИспользованиеВнешнихРесурсов");
	
	// Вызывается при применении запросов на использование внешних ресурсов.
	//
	// Параметры:
	//  ИдентификаторыЗапросов - Массив(УникальныйИдентификатор) - массив идентификаторов запросов,
	//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки расчета дельты,
	//
	// Синтаксис:
	// Процедура ПриПримененииЗапросовНаИспользованиеВнешнихРесурсов(Знач ИдентификаторыЗапросов, СтандартнаяОбработка) Экспорт
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПримененииЗапросовНаИспользованиеВнешнихРесурсов");
	
	// Вызывается после обработки запросов на использование внешних ресурсов.
	//
	// Параметры:
	//  ИдентификаторыЗапросов - Массив(УникальныйИдентификатор) - массив идентификаторов запросов,
	//  РежимВосстановления - Булево, флаг вызова для запросов восстановления разрешений в кластере после
	//    отказа от записи объектов, для которых требовались разрешения на использование внешних ресурсов,
	//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки,
	//
	// Синтаксис:
	// Процедура ПослеОбработкиЗапросовНаИспользованиеВнешнихРесурсов(Знач ИдентификаторыЗапросов, Знач РежимВосстановления, СтандартнаяОбработка) Экспорт
	//
	СерверныеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПослеОбработкиЗапросовНаИспользованиеВнешнихРесурсов");
	
	// КЛИЕНТСКИЕ СОБЫТИЯ.
	
	// Вызывается при обработке запросов на использование внешних ресурсов.
	// 
	// Параметры:
	//  Идентификаторы - Массив(УникальныйИдентификатор), идентификаторы запросов, которые требуется применить,
	//  ФормаВладелец - УправляемаяФорма, форма, которая должна блокироваться до окончания применения разрешений,
	//  ОповещениеОЗакрытии - ОписаниеОповещения, которое будет вызвано при успешном предоставлении разрешений.
	//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки применения разрешений на использование
	//    внешних ресурсов (подключение к агенту сервера через COM-соединение или сервер администрирования с
	//    запросом параметров подключения к кластеру у текущего пользователя). Может быть установлен в значение Ложь
	//    внутри обработчика события, в этом случае стандартная обработка завершения сеанса выполняться не будет.
	//
	// Синтаксис:
	// Процедура ПриОбработкеЗапросовНаИспользованиеВнешнихРесурсов(Знач ИдентификаторыЗапросов, ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт
	//
	КлиентскиеСобытия.Добавить(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОбработкеЗапросовНаИспользованиеВнешнихРесурсов");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Использование профилей безопасности
//

// Возвращает URI пространства имен XDTO-пакета, который используется для описания разрешений
// в профилях безопасности.
//
// Возвращаемое значение: Строка, URI пространства имен XDTO-пакета.
//
Функция ПакетXDTOПредставленийРазрешений() Экспорт
	
	Возврат Метаданные.ПакетыXDTO.ApplicationPermissions_1_0_0_1.ПространствоИмен;
	
КонецФункции

// Проверяет возможность использования профилей безопасности для текущей информационной базы.
//
// Возвращаемое значение: Булево.
//
Функция ВозможноИспользованиеПрофилейБезопасности() Экспорт
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединенияИнформационнойБазы()) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Отказ = Ложь;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПроверкеВозможностиИспользованияПрофилейБезопасности");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриПроверкеВозможностиИспользованияПрофилейБезопасности(Отказ);
		Если Отказ Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	РаботаВБезопасномРежимеПереопределяемый.ПриПроверкеВозможностиИспользованияПрофилейБезопасности(Отказ);
	
	Возврат Не Отказ;
	
КонецФункции

// Проверяет возможность настройки профилей безопасности из текущей информационной базы.
//
// Возвращаемое значение: Булево.
//
Функция ДоступнаНастройкаПрофилейБезопасности() Экспорт
	
	Если ВозможноИспользованиеПрофилейБезопасности() Тогда
		
		Отказ = Ложь;
		
		ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
			"СтандартныеПодсистемы.БазоваяФункциональность\ПриПроверкеВозможностиНастройкиПрофилейБезопасности");
		
		Для Каждого Обработчик Из ОбработчикиСобытия Цикл
			Обработчик.Модуль.ПриПроверкеВозможностиНастройкиПрофилейБезопасности(Отказ);
			Если Отказ Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Возврат Не Отказ;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Выполняет дополнительные (определенные бизнес-логикой) действия при включении
//  использования профилей безопасности.
//
Процедура ПриВключенииИспользованияПрофилейБезопасности() Экспорт
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриВключенииИспользованияПрофилейБезопасности");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриВключенииИспользованияПрофилейБезопасности();
	КонецЦикла;
	
	РаботаВБезопасномРежимеПереопределяемый.ПриВключенииИспользованияПрофилейБезопасности();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Создание запросов разрешений
//

// Создает запрос на изменение разрешений использования внешних ресурсов.
// Только для внутреннего использования.
//
// Параметры:
//  Владелец - ЛюбаяСсылка - владелец разрешений на использование внешних ресурсов
//    (Неопределено при запросе разрешений для конфигурации, а не для объектов конфигурации),
//  РежимЗамещения - Булево - режим замещения ранее предоставленных для владельца разрешений,
//  ДобавляемыеРазрешения - Массив(ОбъектXDTO) - массив ОбъектовXDTO, соответствующих внутренним описаниям
//    запрашиваемых разрешений на доступ к внешним ресурсам. Предполагается, что все ОбъектыXDTO, передаваемые
//    в качестве параметра, сформированы с помощью вызова функций РаботаВБезопасномРежиме.Разрешение*(),
//  УдаляемыеРазрешения - Массив(ОбъектXDTO) - массив ОбъектовXDTO, соответствующих внутренним описаниям
//    отменяемых разрешений на доступ к внешним ресурсам. Предполагается, что все ОбъектыXDTO, передаваемые
//    в качестве параметра, сформированы с помощью вызова функций РаботаВБезопасномРежиме.Разрешение*(),
//  ВнешнийМодуль - ЛюбаяСсылка - ссылка, соответствующая внешнему модулю, для которого запрашиваются
//    разрешения. (Неопределено при запросе разрешений для конфигурации, а не для внешних модулей).
//
// Возвращаемое значение - УникальныйИдентификатор - идентификатор созданного запроса.
//
Функция ЗапросНаИзменениеРазрешенийИспользованияВнешнихРесурсов(Знач Владелец, Знач РежимЗамещения, Знач ДобавляемыеРазрешения = Неопределено, Знач УдаляемыеРазрешения = Неопределено, Знач ВнешнийМодуль = Неопределено) Экспорт
	
	СтандартнаяОбработка = Истина;
	Результат = Неопределено;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриЗапросеРазрешенийНаИспользованиеВнешнихРесурсов");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПриЗапросеРазрешенийНаИспользованиеВнешнихРесурсов(
			Владелец, РежимЗамещения, ДобавляемыеРазрешения, УдаляемыеРазрешения, СтандартнаяОбработка, Результат);
		
		Если Не СтандартнаяОбработка Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтандартнаяОбработка Тогда
		
		Результат = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ЗапросНаИзменениеРазрешенийИспользованияВнешнихРесурсов(
			Владелец, РежимЗамещения, ДобавляемыеРазрешения, УдаляемыеРазрешения, ВнешнийМодуль);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Создает запросы на использование внешних ресурсов для внешнего модуля.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка - ссылка, соответствующая внешнему модулю, для которого запрашиваются разрешения,
//  НовыеРазрешения - Массив(ОбъектXDTO) - массив ОбъектовXDTO, соответствующих внутренним описаниям
//    запрашиваемых разрешений на доступ к внешним ресурсам. Предполагается, что все ОбъектыXDTO, передаваемые
//    в качестве параметра, сформированы с помощью вызова функций РаботаВБезопасномРежиме.Разрешение*().
//    При запросе разрешений для внешних модулей добавление разрешений всегда выполняется в режиме замещения.
//
// Возвращаемое значение - Массив(УникальныйИдентификатор) - идентификаторы созданных запросов.
//
Функция ЗапросыНаИспользованиеВнешнихРесурсовДляВнешнегоМодуля(Знач ВнешнийМодуль, Знач НовыеРазрешения = Неопределено) Экспорт
	
	Результат = Новый Массив();
	
	Если НовыеРазрешения = Неопределено Тогда
		НовыеРазрешения = Новый Массив();
	КонецЕсли;
	
	Если НовыеРазрешения.Количество() > 0 Тогда
		
		// Если профиля безопасности еще нет - его требуется создать
		Если РежимПодключенияВнешнегоМодуля(ВнешнийМодуль) = Неопределено Тогда
			Результат.Добавить(ЗапросНаСозданиеНабораРазрешений(ВнешнийМодуль));
		КонецЕсли;
		
		Результат.Добавить(
			ЗапросНаИзменениеРазрешенийИспользованияВнешнихРесурсов(
				ВнешнийМодуль, Истина, НовыеРазрешения, Неопределено, ВнешнийМодуль
			)
		);
		
	Иначе
		
		// Если профиль безопасности есть - его требуется удалить
		Если РежимПодключенияВнешнегоМодуля(ВнешнийМодуль) <> Неопределено Тогда
			Результат.Добавить(ЗапросНаУдалениеНабораРазрешений(ВнешнийМодуль));
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Создает запрос на создание профиля безопасности для внешнего модуля.
// Только для внутреннего использования.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка - ссылка, соответствующая внешнему модулю, для которого запрашиваются
//    разрешения. (Неопределено при запросе разрешений для конфигурации, а не для внешних модулей).
//
// Возвращаемое значение - УникальныйИдентификатор - идентификатор созданного запроса.
//
Функция ЗапросНаСозданиеНабораРазрешений(Знач ВнешнийМодуль) Экспорт
	
	СтандартнаяОбработка = Истина;
	Результат = Неопределено;
	Операция = Перечисления.ОперацииСНаборамиРазрешений.Создание;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриЗапросеНаАдминистрированиеРазрешенийИспользованияВнешнихРесурсов");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПриЗапросеНаАдминистрированиеРазрешенийИспользованияВнешнихРесурсов(
			ВнешнийМодуль, Операция, СтандартнаяОбработка, Результат);
		
		Если Не СтандартнаяОбработка Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтандартнаяОбработка Тогда
		
		Результат = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ЗапросНаАдминистрированиеРазрешенийИспользованияВнешнихРесурсов(
			ВнешнийМодуль, Операция);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Создает запрос на удаление профиля безопасности для внешнего модуля.
// Только для внутреннего использования.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка - ссылка, соответствующая внешнему модулю, для которого запрашиваются
//    разрешения. (Неопределено при запросе разрешений для конфигурации, а не для внешних модулей).
//
// Возвращаемое значение - УникальныйИдентификатор - идентификатор созданного запроса.
//
Функция ЗапросНаУдалениеНабораРазрешений(Знач ВнешнийМодуль) Экспорт
	
	СтандартнаяОбработка = Истина;
	Результат = Неопределено;
	Операция = Перечисления.ОперацииСНаборамиРазрешений.Удаление;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриЗапросеНаАдминистрированиеРазрешенийИспользованияВнешнихРесурсов");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПриЗапросеНаАдминистрированиеРазрешенийИспользованияВнешнихРесурсов(
			ВнешнийМодуль, Операция, СтандартнаяОбработка, Результат);
		
		Если Не СтандартнаяОбработка Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтандартнаяОбработка Тогда
		
		Результат = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ЗапросНаАдминистрированиеРазрешенийИспользованияВнешнихРесурсов(
			ВнешнийМодуль, Операция);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Создает запросы на обновление разрешений конфигурации.
//
// Параметры:
//  ВключаяЗапросСозданияПрофиляИБ - Булево - включать в результат запрос на создание профиля безопасности
//    для текущей информационной базы.
//
// Возвращаемое значение: Массив(УникальныйИдентификатор) - идентификаторы запросов для обновления разрешений конфигурации
//  до требуемых в настоящий момент.
//
Функция ЗапросыНаОбновлениеРазрешенийКонфигурации(Знач ВключаяЗапросСозданияПрофиляИБ = Истина) Экспорт
	
	Результат = Новый Массив();
	
	НачатьТранзакцию();
	
	Попытка
		
		Если ВключаяЗапросСозданияПрофиляИБ Тогда
			Результат.Добавить(ЗапросНаСозданиеНабораРазрешений(Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка()));
		КонецЕсли;
		
		ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
			"СтандартныеПодсистемы.БазоваяФункциональность\ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам");
		Для Каждого Обработчик Из ОбработчикиСобытия Цикл
			Обработчик.Модуль.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(Результат);
		КонецЦикла;
		
		РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(Результат);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Применение запросов разрешений на использование внешних ресурсов
//

// Формирует представление разрешений на использование внешних ресурсов по таблицам разрешений.
//
// Параметры:
//  Таблицы - Структура - таблицы разрешений, для которых формируется представление
//    (см. ТаблицыРазрешений()).
//
// Возвращаемое значение: ТабличныйДокумент, представление разрешений на использование внешних ресурсов.
//
Функция ПредставлениеРазрешенийНаИспользованиеВнешнихРесурсов(Знач ТаблицыРазрешений) Экспорт
	
	Возврат Отчеты.ИспользуемыеВнешниеРесурсы.ПредставлениеРазрешенийНаИспользованиеВнешнихРесурсов(ТаблицыРазрешений);
	
КонецФункции

// Применяет запросы на использование внешних ресурсов (должна вызываться после изменения настроек
// профилей безопасности в кластере серверов).
//
// Параметры:
//  ИдентификаторыЗапросов - Массив(УникальныйИдентификатор) - идентификаторы применяемых запросов.
//
Процедура ПрименитьЗапросы(Знач ИдентификаторыЗапросов) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		СтандартнаяОбработка = Истина;
		
		ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
			"СтандартныеПодсистемы.БазоваяФункциональность\ПриПримененииЗапросовНаИспользованиеВнешнихРесурсов");
		Для Каждого Обработчик Из ОбработчикиСобытия Цикл
			
			Обработчик.Модуль.ПриПримененииЗапросовНаИспользованиеВнешнихРесурсов(ИдентификаторыЗапросов, СтандартнаяОбработка);
			
			Если Не СтандартнаяОбработка Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если СтандартнаяОбработка Тогда
			
			Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ПрименитьЗапросы(ИдентификаторыЗапросов);
			
		КонецЕсли;
		
		ПослеОбработкиЗапросов(ИдентификаторыЗапросов);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Выполняет дополнительные действия после применения запросов на использование внешних ресурсов.
//
// Параметры:
//  ИдентификаторыЗапросов - Массив(УникальныйИдентификатор) - идентификаторы применяемых запросов.
//
Процедура ПослеОбработкиЗапросов(Знач ИдентификаторыЗапросов) Экспорт
	
	СтандартнаяОбработка = Истина;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПослеОбработкиЗапросовНаИспользованиеВнешнихРесурсов");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПослеОбработкиЗапросовНаИспользованиеВнешнихРесурсов(ИдентификаторыЗапросов, Ложь, СтандартнаяОбработка);
		
		Если Не СтандартнаяОбработка Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтандартнаяОбработка Тогда
		
		Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ПослеОбработкиЗапросов(ИдентификаторыЗапросов);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Внешние модули
//

// Возвращает режим подключения внешнего модуля.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка, ссылка, соответствующая внешнему модулю, для которого запрашиваются
//    режим подключения.
//
// Возвращаемое значение: Строка - имя профиля безопасности, который должен использоваться для подключения
//  внешнего модуля. Если для внешнего модуля не зарегистрирован режим подключения - возвращается Неопределено.
//
Функция РежимПодключенияВнешнегоМодуля(Знач ВнешнийМодуль) Экспорт
	
	Возврат Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.РежимПодключенияВнешнегоМодуля(ВнешнийМодуль);
	
КонецФункции

// Возвращает программный модуль, выполняющий функции менеджера внешнего модуля.
//
//  ВнешнийМодуль - ЛюбаяСсылка, ссылка, соответствующая внешнему модулю, для которого запрашиваются
//    менеджер.
//
// Возвращаемое значение: ОбщийМодуль.
//
Функция МенеджерВнешнегоМодуля(Знач ВнешнийМодуль) Экспорт
	
	Контейнеры = Новый Массив();
	
	Менеджеры = МенеджерыВнешнихМодулей();
	Для Каждого Менеджер Из Менеджеры Цикл
		КонтейнерыМенеджера = Менеджер.КонтейнерыВнешнихМодулей();
		
		Если ТипЗнч(ВнешнийМодуль) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
			ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ВнешнийМодуль);
		Иначе
			ОбъектМетаданных = ВнешнийМодуль.Метаданные();
		КонецЕсли;
		
		Если КонтейнерыМенеджера.Найти(ОбъектМетаданных) <> Неопределено Тогда
			Возврат Менеджер;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Контроль записи служебных данных
//

// Вызывается при записи элемента справочника, использующегося в качестве контейнера внешних модулей.
//
// Параметры:
//  Источник - СправочникОбъект - записываемый элемент справочника,
//  Отказ - Булево - флаг отказа от записи.
//
Процедура ПриЗаписиКонтейнераВнешнегоМодуля(Источник, Отказ) Экспорт
	
	ПриЗаписиСлужебныхДанных(Источник);
	
КонецПроцедуры

// Процедура должна вызываться при записи любых служебных данных, изменение которых должно быть
// недопустимо при установленном безопасном режиме.
//
Процедура ПриЗаписиСлужебныхДанных(Объект) Экспорт
	
	Если РаботаВБезопасномРежиме.УстановленБезопасныйРежим() Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Запись объекта %1 недоступна: установлен безопасный режим: %2!'"),
			Объект.Метаданные().ПолноеИмя(),
			БезопасныйРежим()
		);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Декларация обработчиков программных событий
//

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
//
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"РаботаВБезопасномРежимеСлужебный");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.ВариантыОтчетов\ПриНастройкеВариантовОтчетов"].Добавить(
			"РаботаВБезопасномРежимеСлужебный");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий
//

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - См. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления().
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ПриДобавленииОбработчиковОбновления(
		Обработчики);
	
КонецПроцедуры

// Содержит настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ИспользуемыеВнешниеРесурсы);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов
//

Процедура ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ДобавитьПараметрыРаботыКлиента(Параметры);
	
КонецПроцедуры

Процедура ДобавитьПараметрыРаботыКлиента(Параметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Параметры.Вставить("ОтображатьПомощникНастройкиРазрешений", ИспользуетсяИнтерактивныйРежимЗапросаРазрешений());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Использование профилей безопасности
//

// Проверяет, требуется ли использовать интерактивный режим запроса разрешений.
//
// Возвращаемое значение: Булево.
//
Функция ИспользуетсяИнтерактивныйРежимЗапросаРазрешений()
	
	Если ВозможноИспользованиеПрофилейБезопасности() Тогда
		
		Возврат ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") И Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Получить();
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Внешние модули
//

// Возвращает массив менеджеров справочников, которые являются контейнерами внешних модулей.
//
// Возвращаемое значение: Массив(СправочникМенеджер).
//
Функция МенеджерыВнешнихМодулей()
	
	Менеджеры = Новый Массив();
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриРегистрацииМенеджеровВнешнихМодулей");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриРегистрацииМенеджеровВнешнихМодулей(Менеджеры);
	КонецЦикла;
	
	Возврат Менеджеры;
	
КонецФункции

#КонецОбласти
