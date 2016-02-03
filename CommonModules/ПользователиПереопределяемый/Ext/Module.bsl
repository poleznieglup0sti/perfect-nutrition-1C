﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет стандартный способ установки ролей пользователям ИБ.
//
// Параметры:
//  Запрет - Булево - если установить Истина, изменение ролей
//           блокируется (в том числе для администратора).
//
Процедура ИзменитьЗапретРедактированияРолей(Запрет) Экспорт
	
КонецПроцедуры

// Переопределяет поведение формы пользователя и формы внешнего пользователя,
// группы внешних пользователей.
//
// Параметры:
//  Ссылка - СправочникСсылка.Пользователи,
//           СправочникСсылка.ВнешниеПользователи,
//           СправочникСсылка.ГруппыВнешнихПользователей - ссылка на пользователя,
//           внешнего пользователя или группу внешних пользователей при создании формы.
//
//  ДействияВФорме - Структура - со свойствами:
//         * Роли                   - Строка - "", "Просмотр",     "Редактирование".
//         * КонтактнаяИнформация   - Строка - "", "Просмотр",     "Редактирование".
//         * СвойстваПользователяИБ - Строка - "", "Просмотр",     "Редактирование".
//         * СвойстваЭлемента       - Строка - "", "Просмотр",     "Редактирование".
//           
//           Для групп внешних пользователей КонтактнаяИнформация и СвойстваПользователяИБ не существуют.
//
Процедура ИзменитьДействияВФорме(Знач Ссылка, Знач ДействияВФорме) Экспорт
	
КонецПроцедуры

// Доопределяет действия при записи пользователя информационной базы.
//  Вызывается из процедуры ЗаписатьПользователяИБ(), если пользователь был действительно изменен.
//
// Параметры:
//  СтарыеСвойства - Структура - см. параметры возвращаемые функцией Пользователи.ПрочитатьПользователяИБ().
//  НовыеСвойства  - Структура - см. параметры возвращаемые функцией Пользователи.ЗаписатьПользователяИБ().
//
Процедура ПриЗаписиПользователяИнформационнойБазы(Знач СтарыеСвойства, Знач НовыеСвойства) Экспорт
	
КонецПроцедуры

// Доопределяет действия после удаления пользователя информационной базы.
//  Вызывается из процедуры УдалитьПользователяИБ(), если пользователь был удален.
//
// Параметры:
//  СтарыеСвойства - Структура - см. параметры возвращаемые функцией Пользователи.ПрочитатьПользователяИБ().
//
Процедура ПослеУдаленияПользователяИнформационнойБазы(Знач СтарыеСвойства) Экспорт
	
КонецПроцедуры

// Переопределяет настройки интерфейса, устанавливаемые для новых пользователей.
//
// Параметры:
//  НачальныеНастройки - Структура - настройки по умолчанию:
//   * НастройкиКлиента    - НастройкиКлиентскогоПриложения           - настройки клиентского приложения.
//   * НастройкиИнтерфейса - НастройкиКомандногоИнтерфейса            - настройки командного интерфейса (панели разделов, панели навигации, панели действий).
//   * НастройкиТакси      - НастройкиИнтерфейсаКлиентскогоПриложения - настройки интерфейса клиентского приложения (состав и размещение панелей).
//
Процедура ПриУстановкеНачальныхНастроек(НачальныеНастройки) Экспорт
	
	// _Демо начало примера
	НачальныеНастройки.НастройкиИнтерфейса.ОтображениеПанелиРазделов = ОтображениеПанелиРазделов.КартинкаИТекст;
	// _Демо конец примера
	
КонецПроцедуры

// Дополняет список настроек переданного пользователя на вкладке "Прочее" обработки НастройкиПользователей.
//
// Параметры:
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка  - СправочникСсылка.Пользователи - пользователь,
//                               у которого нужно получить настройки.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             у которого нужно получить настройки.
//  Настройки - Структура - прочие пользовательские настройки.
//       * Ключ     - Строка - строковый идентификатор настройки, используемый в дальнейшем
//                             для копирования и очистки этой настройки.
//       * Значение - Структура - информация о настройке.
//              ** НазваниеНастройки  - Строка - название, которое будет отображаться в дереве настроек.
//              ** КартинкаНастройки  - Картинка - картинка, которая будет отображаться в дереве настроек.
//              ** СписокНастроек     - СписокЗначений - список полученных настроек.
//
Процедура ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	// _Демо начало примера
	
	// Получение значения настройки ЗапрашиватьПодтверждениеПриЗавершенииПрограммы.
	ЗначениеНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",,,
			СведенияОПользователе.ИмяПользователяИнформационнойБазы);
	Если ЗначениеНастройки <> Неопределено Тогда
		
		СписокЗначенийНастройки = Новый СписокЗначений;
		СписокЗначенийНастройки.Добавить(ЗначениеНастройки);
		
		ИнформацияОНастройке    = Новый Структура;
		ИнформацияОНастройке.Вставить("НазваниеНастройки", НСтр("ru = 'Подтверждение при закрытии программы'"));
		ИнформацияОНастройке.Вставить("КартинкаНастройки", "");
		ИнформацияОНастройке.Вставить("СписокНастроек", СписокЗначенийНастройки);
		
		Настройки.Вставить("ЗапрашиватьПодтверждениеОЗакрытии", ИнформацияОНастройке);
	КонецЕсли;
	
	// _Демо конец примера
	
КонецПроцедуры

// Сохраняет настройки переданному пользователю.
//
// Параметры:
//  Настройки             - СписокЗначений - список значений сохраняемых настроек.
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно скопировать настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно скопировать настройку.
//
Процедура ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	// _Демо начало примера
	
	Если Настройки.ИдентификаторНастройки = "ЗапрашиватьПодтверждениеОЗакрытии" Тогда
		ЗначениеНастройки = Настройки.ЗначениеНастройки[0];
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
			ЗначениеНастройки.Значение,, СведенияОПользователе.ИмяПользователяИнформационнойБазы);
	КонецЕсли;
	
	// _Демо конец примера
	
КонецПроцедуры

// Очищает настройки переданному пользователю.
//
// Параметры:
//  Настройки             - СписокЗначений - список значений очищаемых настроек
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно очистить настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно очистить настройку.
//
Процедура ПриУдаленииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	// _Демо начало примера
	
	Если Настройки.ИдентификаторНастройки = "ЗапрашиватьПодтверждениеОЗакрытии" Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(
			"ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
			СведенияОПользователе.ИмяПользователяИнформационнойБазы);
	КонецЕсли;
	
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
