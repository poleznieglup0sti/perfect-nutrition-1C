﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ"
// Серверные процедуры и функции обновления информационной базы
// при смене версии конфигурации.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверить необходимость обновления информационной базы при смене версии конфигурации.
//
// Возвращаемое значение:
//   Булево
//
Функция НеобходимоОбновлениеИнформационнойБазы() Экспорт
	
	Возврат ОбновлениеИнформационнойБазыСлужебныйПовтИсп.НеобходимоОбновлениеИнформационнойБазы();
	
КонецФункции

// Возвращает Истина, если в данный момент выполняется обновление ИБ.
//
// Возвращаемое значение:
//   Булево
//
Функция ВыполняетсяОбновлениеИнформационнойБазы() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат НеобходимоОбновлениеИнформационнойБазы();
	КонецЕсли;
	
	Возврат ПараметрыСеанса.ВыполняетсяОбновлениеИБ;
	
КонецФункции

// Возвращает пустую таблицу обработчиков обновления и первоначального заполнения ИБ.
//
// Возвращаемое значение:
//   ТаблицаЗначений   - таблица с колонками:
//     * НачальноеЗаполнение - Булево - если Истина, то обработчик должен срабатывать при запуске на "пустой" базе.
//     * Версия              - Строка - например, "2.1.3.39". Номер версии конфигурации, при переходе
//                                      на которую должна быть выполнена процедура-обработчик обновления.
//                                      Если указана пустая строка, то это обработчик только для начального заполнения
//                                      (должно быть указано свойство НачальноеЗаполнение).
//     * Процедура           - Строка - полное имя процедуры-обработчика обновления/начального заполнения. 
//                                      Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьНовыйРеквизит"
//                                      Обязательно должна быть экспортной.
//
//     * ВыполнятьВГруппеОбязательных - Булево - следует указывать, если обработчик требуется
//                                      выполнять в одной группе с обработчиками на версии "*".
//                                      При этом, возможно менять порядок выполнения обработчика
//                                      относительно других путем изменения приоритета.
//     * Приоритет           - Число  - для внутреннего использования.
//
//     * ОбщиеДанные         - Булево - если Истина, то обработчик должен срабатывать до
//                                      выполнения любых обработчиков, использующих разделенные данные.
//     * УправлениеОбработчиками - Булево - если Истина, то обработчик должен иметь параметр типа структура, в котором есть свойство 
//                                      РазделенныеОбработчики - таблица значений со структурой, возвращаемой этой функцией. 
//                                      При этом колонка Версия игнорируется. В случае необходимости выполнения разделенного обработчика,
//                                      в данную таблицу необходимо добавить строку с описанием процедуры обработчика.
//                                      Имеет смысл только для обязательных (Версия = *) обработчиков обновления 
//                                      с установленным флагом ОбщиеДанные.
//     * Комментарий         - Строка - описание действий, выполняемых обработчиком обновления.
//     * РежимВыполнения     - Строка - режим выполнения обработчика обновления. Допустимые значения:
//                                      Монопольно, Отложенно, Оперативно. Если значение не заполнено, обработчик считается монопольным.
//     * МонопольныйРежим    - Неопределено, Булево - если указано Неопределено, то обработчик 
//                                      должен безусловно выполняться в монопольном режиме.
//                                      Для обработчиков перехода на конкретную версию (версия <> *):
//                                        Ложь   - обработчик не требует монопольного режима для выполнения.
//                                        Истина - обработчик требует монопольного режима для выполнения.
//                                      Для обязательных обработчиков обновления (Версия = "*"):
//                                        Ложь   - обработчик не требует монопольного режима.
//                                        Истина - обработчик может требовать монопольного режима для выполнения.
//                                                 В такие обработчики передается параметр типа структура
//                                                 со свойством МонопольныйРежим (типа Булево).
//                                                 При запуске обработчика в монопольном режиме передается
//                                                 значение Истина. В этом случае обработчик должен выполнить
//                                                 требуемые действия по обновлению. Изменение параметра
//                                                 в теле обработчика игнорируется.
//                                                 При запуске обработчика в немонопольном режиме передается
//                                                 значение Ложь. В этом случае обработчик не должен вносить никакие изменения в ИБ.
//                                                 Если в результате анализа выясняется что обработчику требуется
//                                                 изменить данные ИБ следует установить значение параметра в
//                                                 Истина и прекратить выполнение обработчика.
//                                                 В этом случае оперативное (немонопольное обновление ИБ) будет
//                                                 отменено и выдана ошибка с требованием выполнить обновление в монопольном режиме.
//
Функция НоваяТаблицаОбработчиковОбновления() Экспорт
	
	Обработчики = Новый ТаблицаЗначений;
	// Основные свойства.
	Обработчики.Колонки.Добавить("НачальноеЗаполнение", Новый ОписаниеТипов("Булево"));
	Обработчики.Колонки.Добавить("Версия",    Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(0)));
	Обработчики.Колонки.Добавить("Процедура", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(0)));
	Обработчики.Колонки.Добавить("Комментарий", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(0)));
	Обработчики.Колонки.Добавить("РежимВыполнения", Новый ОписаниеТипов("Строка"));
	// Дополнительные свойства (для библиотек).
	Обработчики.Колонки.Добавить("ВыполнятьВГруппеОбязательных", Новый ОписаниеТипов("Булево"));
	Обработчики.Колонки.Добавить("Приоритет", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(2)));
	// Поддержка модели сервиса.
	Обработчики.Колонки.Добавить("ОбщиеДанные",             Новый ОписаниеТипов("Булево"));
	Обработчики.Колонки.Добавить("УправлениеОбработчиками", Новый ОписаниеТипов("Булево"));
	Обработчики.Колонки.Добавить("МонопольныйРежим");
	
	// Устарело. Обратная совместимость до редакции "2.2".
	Обработчики.Колонки.Добавить("Опциональный");
	
	Возврат Обработчики;
	
КонецФункции

// Выполнить обработчики обновления из списка ОбработчикиОбновления 
// для библиотеки ИдентификаторБиблиотеки до версии ВерсияМетаданныхИБ.
//
// Параметры
//   ИдентификаторБиблиотеки  - Строка       - имя конфигурации или идентификатор библиотеки.
//   ВерсияМетаданныхИБ       - Строка       - версия метаданных, до которой необходимо выполнить обновление.
//   ОбработчикиОбновления    - Соответствие - список обработчиков обновления.
//
// Возвращаемое значение:
//   ДеревоЗначений   - выполненные обработчики обновления.
//
Функция ВыполнитьИтерациюОбновления(Знач ИдентификаторБиблиотеки, Знач ВерсияМетаданныхИБ, 
	Знач ОбработчикиОбновления, Знач ХодВыполненияОбработчиков, Знач ОперативноеОбновление = Ложь) Экспорт
	
	ИтерацияОбновления = ОбновлениеИнформационнойБазыСлужебный.ИтерацияОбновления(ИдентификаторБиблиотеки, 
		ВерсияМетаданныхИБ, ОбработчикиОбновления);
		
	Параметры = Новый Структура;
	Параметры.Вставить("ХодВыполненияОбработчиков", ХодВыполненияОбработчиков);
	Параметры.Вставить("ОперативноеОбновление", ОперативноеОбновление);
	Параметры.Вставить("ВФоне", Ложь);
	
	Возврат ОбновлениеИнформационнойБазыСлужебный.ВыполнитьИтерациюОбновления(ИтерацияОбновления, 
		ХодВыполненияОбработчиков, ОперативноеОбновление);
	
КонецФункции

// Выполнить неинтерактивное обновление данных ИБ.
// Для вызова через внешнее соединение.
// 
// Для использования в других библиотеках и конфигурациях.
//
// Возвращаемое значение:
//  Строка -  признак выполнения обработчиков обновления:
//           "Успешно", "НеТребуется", "ОшибкаУстановкиМонопольногоРежима".
//
Функция ВыполнитьОбновлениеИнформационнойБазы() Экспорт
	
	Возврат ОбновлениеИнформационнойБазыСлужебный.ВыполнитьОбновлениеИнформационнойБазы();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для использования в обработчиках обновления.
//

// Записывает изменения в переданном объекте.
// Для использования в обработчиках обновления.
//
// Параметры:
//   Данные                            - Произвольный - объект, набор записей или менеджер константы, который необходимо записать.
//   РегистрироватьНаУзлахПлановОбмена - Булево       - включает регистрацию на узлах планов обмена при записи объекта.
//   ВключитьБизнесЛогику              - Булево       - включает бизнес-логику при записи объекта.
//
Процедура ЗаписатьДанные(Знач Данные, Знач РегистрироватьНаУзлахПлановОбмена = Ложь, 
	Знач ВключитьБизнесЛогику = Ложь) Экспорт
	
	Данные.ОбменДанными.Загрузка = Не ВключитьБизнесЛогику;
	Если Не РегистрироватьНаУзлахПлановОбмена Тогда
		Данные.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		Данные.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	Данные.Записать();
	
КонецПроцедуры

// Удаляет переданный объект.
// Для использования в обработчиках обновления.
//
// Параметры:
//  Данные                            - Произвольный - объект, который необходимо удалить.
//  РегистрироватьНаУзлахПлановОбмена - Булево       - включает регистрацию на узлах планов обмена при записи объекта.
//  ВключитьБизнесЛогику              - Булево       - включает бизнес-логику при записи объекта.
//
Процедура УдалитьДанные(Знач Данные, Знач РегистрироватьНаУзлахПлановОбмена = Ложь, 
	Знач ВключитьБизнесЛогику = Ложь) Экспорт
	
	Данные.ОбменДанными.Загрузка = Не ВключитьБизнесЛогику;
	Если Не РегистрироватьНаУзлахПлановОбмена Тогда
		Данные.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		Данные.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	Данные.Удалить();
	
КонецПроцедуры

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат ОбновлениеИнформационнойБазыСлужебный.СобытиеЖурналаРегистрации();
	
КонецФункции

// Получить версию конфигурации или родительской конфигурации (библиотеки),
// которая хранится в информационной базе.
//
// Параметры:
//  ИдентификаторБиблиотеки   - Строка - имя конфигурации или идентификатор библиотеки.
//
// Возвращаемое значение:
//   Строка   - версия.
//
// Пример использования:
//   ВерсияКонфигурацииИБ = ВерсияИБ(Метаданные.Имя);
//
Функция ВерсияИБ(Знач ИдентификаторБиблиотеки) Экспорт
	
	Возврат ОбновлениеИнформационнойБазыСлужебный.ВерсияИБ(ИдентификаторБиблиотеки);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции.
//

// Возвращает таблицу с версиями подсистем конфигурации.
// Для пакетной выгрузки-загрузки сведений о версиях подсистем.
//
// Возвращаемое значение:
//   ТаблицаЗначений - таблица с колонками:
//     * ИмяПодсистемы - Строка - имя подсистемы.
//     * Версия        - Строка - версия подсистемы.
//
Функция ВерсииПодсистем() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВерсииПодсистем.ИмяПодсистемы КАК ИмяПодсистемы,
	|	ВерсииПодсистем.Версия КАК Версия
	|ИЗ
	|	РегистрСведений.ВерсииПодсистем КАК ВерсииПодсистем";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции 

// Устанавливает версии всех подсистем.
// Для пакетной выгрузки-загрузки сведений о версиях подсистем.
//
// Параметры:
//   ВерсииПодсистем - ТаблицаЗначений - таблица с колонками:
//     * ИмяПодсистемы - Строка - имя подсистемы.
//     * Версия        - Строка - версия подсистемы.
//
Процедура УстановитьВерсииПодсистем(ВерсииПодсистем) Экспорт

	НаборЗаписей = РегистрыСведений.ВерсииПодсистем.СоздатьНаборЗаписей();
	
	Для каждого Версия Из ВерсииПодсистем Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ИмяПодсистемы = Версия.ИмяПодсистемы;
		НоваяЗапись.Версия = Версия.Версия;
		НоваяЗапись.ЭтоОсновнаяКонфигурация = (Версия.ИмяПодсистемы = Метаданные.Имя);
	КонецЦикла;
	
	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти

