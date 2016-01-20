﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Заполняет список всех возможных областей для поиска дублей
// 
// Параметры:
//     Список - СписокЗначений - Заполняемый список, в котором устанавливаются:
//               Значение      - Строка   - Полное имя метаданных объекта-таблицы
//               Представление - Строка   - Представление для пользователя
//               Картинка      - Картинка - Соответствующая картинка из платформенной библиотеки
//               Пометка       - Булево   - Флаг наличия прикладных правил поиска дублей. 
//                                          Устанавливается только если второй параметр равен Истина
//
//     АнализироватьПрикладныеПравила - Булево - Флаг необходимости поиска прикладных правил поиска дублей
//
Процедура ОбластиПоискаДублей(Список, Знач АнализироватьПрикладныеПравила = Ложь) Экспорт
	
	Список.Очистить();
	
	ГруппаОбластейПоискаДублей(Список, АнализироватьПрикладныеПравила, Справочники,             "Справочник");
	ГруппаОбластейПоискаДублей(Список, АнализироватьПрикладныеПравила, ПланыВидовХарактеристик, "ПланВидовХарактеристик");
	ГруппаОбластейПоискаДублей(Список, АнализироватьПрикладныеПравила, ПланыСчетов,             "ПланСчетов");
	ГруппаОбластейПоискаДублей(Список, АнализироватьПрикладныеПравила, ПланыВидовРасчета,       "ПланВидовРасчета");

КонецПроцедуры

// Определение менеджера объекта для вызова прикладных правил
// 
// Параметры:
//     ИмяОбластиПоискаДанных - Строка - Имя области (полное имя метаданных)
//
// Возвращаемое значение:
//     СправочникиМенеджер, ПланыВидовХарактеристик.Менеджер, ПланыСчетовПланыВидовРасчета.Менеджер
//
Функция МенеджерОбластиПоискаДублей(Знач ИмяОбластиПоискаДанных) Экспорт
	Мета = Метаданные.НайтиПоПолномуИмени(ИмяОбластиПоискаДанных);
	
	Если Метаданные.Справочники.Содержит(Мета) Тогда
		Возврат Справочники[Мета.Имя];
		
	ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(Мета) Тогда
		Возврат ПланыВидовХарактеристик[Мета.Имя];
		
	ИначеЕсли Метаданные.ПланыСчетов.Содержит(Мета) Тогда
		Возврат ПланыСчетов[Мета.Имя];
		
	ИначеЕсли Метаданные.ПланыВидовРасчета.Содержит(Мета) Тогда
		Возврат ПланыВидовРасчета[Мета.Имя];
		
	КонецЕсли;
		
	ВызватьИсключение СтрЗаменить(
		НСтр("ru = 'Неизвестный тип объекта метаданных ""%1""'"), 
		"%1", ИмяОбластиПоискаДанных
	);
	
КонецФункции

// Параметры по умолчанию для передачи в прикладной код
// 
// Параметры:
//     ПравилаПоиска - ТаблицаЗначений - Предлагаемые правила поиска, содержит колонки
//         Реквизит - Строка - Имя реквизита области поиска
//         Правило  - Строка - Идентификатор правила сравнения, "Равно" или "Подобно"
//
// Возвращаемое значение:
//     Структура
//
Функция ПрикладныеПараметрыПоУмолчанию(Знач ПравилаПоиска, Знач КомпоновщикОтбора) Экспорт

	ПараметрыПоУмолчанию = Новый Структура;
	ПараметрыПоУмолчанию.Вставить("ПравилаПоиска",        ПравилаПоиска);
	ПараметрыПоУмолчанию.Вставить("ОграниченияСравнения", Новый Массив);
	ПараметрыПоУмолчанию.Вставить("КомпоновщикОтбора",    КомпоновщикОтбора);
	ПараметрыПоУмолчанию.Вставить("КоличествоЭлементовДляСравнения", 1000);
	
	Возврат ПараметрыПоУмолчанию;
	
КонецФункции

// Обработчик фонового поиска дублей
//
// Параметры:
//     Параметры       - Структура - Данные для анализа
//     АдресРезультата - Строка    - Адрес во временном хранилище для сохранения результата
//
Процедура ФоновыйПоискДублей(Знач Параметры, Знач АдресРезультата) Экспорт
	
	// Собираем компоновщик повторно через схему и настройки
	КомпоновщикПредварительногоОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	КомпоновщикПредварительногоОтбора.Инициализировать( Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.СхемаКомпоновки) );
	КомпоновщикПредварительногоОтбора.ЗагрузитьНастройки(Параметры.НастройкиКомпоновщикаПредварительногоОтбора);
	
	Параметры.Вставить("КомпоновщикПредварительногоОтбора", КомпоновщикПредварительногоОтбора);
	
	// Преобразуем правила поиска в таблицу значений с индексом
	ПравилаПоиска = Новый ТаблицаЗначений;
	ПравилаПоиска.Колонки.Добавить("Реквизит", Новый ОписаниеТипов("Строка") );
	ПравилаПоиска.Колонки.Добавить("Правило",  Новый ОписаниеТипов("Строка") );
	ПравилаПоиска.Индексы.Добавить("Реквизит");
	
	Для Каждого Правило Из Параметры.ПравилаПоиска Цикл
		ЗаполнитьЗначенияСвойств(ПравилаПоиска.Добавить(), Правило);
	КонецЦикла;
	Параметры.Вставить("ПравилаПоиска", ПравилаПоиска);
	
	Параметры.Вставить("РассчитыватьМестаИспользования", Истина);
	
	// Запускаем поиск
	ПоместитьВоВременноеХранилище(ГруппыДублей(Параметры), АдресРезультата);
КонецПроцедуры

// Обработчик фонового удаления дублей
//
// Параметры:
//     Параметры       - Структура - Данные для анализа
//     АдресРезультата - Строка    - Адрес во временном хранилище для сохранения результата
//
Процедура ФоновоеУдалениеДублей(Знач Параметры, Знач АдресРезультата) Экспорт
	
	ПараметрыЗамены = Новый Структура;
	ПараметрыЗамены.Вставить("СпособУдаления",       Параметры.СпособУдаления);
	ПараметрыЗамены.Вставить("ВключатьБизнесЛогику", Истина);
	
	ЗаменитьСсылки(Параметры.ПарыЗамен, ПараметрыЗамены, АдресРезультата);
	
КонецПроцедуры

// Непосредственный поиск дублей
//
// Параметры:
//     ПараметрыПоиска - Структура - Описывает параметры поиска
//     ЭталонныйОбъект - Произвольный - Объект для сравнения при поиски похожих элементов 
//
// Возвращаемое значение:
//     ТаблицаЗначений - Реализация дерева значений через Ссылка и Родитель, 
//                       верхний уровень - группы, нижний - найденные дубли
//
Функция ГруппыДублей(Знач ПараметрыПоиска, Знач ЭталонныйОбъект = Неопределено) Экспорт
	Перем РазмерВозвращаемойПорции, РассчитыватьМестаИспользования;
	
	// 1. Определяем параметры с учетом прикладного кода
	
	ПараметрыПоиска.Свойство("МаксимальноеЧислоДублей", РазмерВозвращаемойПорции);
	Если Не ЗначениеЗаполнено(РазмерВозвращаемойПорции) Тогда
		// Все найденные
		РазмерВозвращаемойПорции = 0;
	КонецЕсли;
	
	Если Не ПараметрыПоиска.Свойство("РассчитыватьМестаИспользования", РассчитыватьМестаИспользования) Тогда
		РассчитыватьМестаИспользования = Ложь;
	КонецЕсли;
		
	// Для передачи в прикладной код
	ДополнительныеПараметры = Неопределено;
	ПараметрыПоиска.Свойство("ДополнительныеПараметры", ДополнительныеПараметры);
	
	// Вызываем прикладной код
	МенеджерОбластиПоиска = МенеджерОбластиПоискаДублей(ПараметрыПоиска.ОбластьПоискаДублей);
	ИспользоватьПрикладныеПравила = ПараметрыПоиска.УчитыватьПрикладныеПравила И ЕстьПрикладныеПравилаОбластиПоискаДублей(МенеджерОбластиПоиска);
	
	ПоляСравненияНаРавенство = "";	// Имена реквизитов, по которым сравниваем по равенству
	ПоляСравненияНаПодобие   = "";	// Имена реквизитов, по которым будем нечетко сравнивать 
	ПоляДополнительныхДанных = "";	// Имена реквизитов, дополнительно заказанные прикладными правилами
	РазмерПрикладнойПорции   = 0;	// Сколько отдавать в прикладные правила для расчета
	
	Если ИспользоватьПрикладныеПравила Тогда
		ПрикладныеПараметры = ПрикладныеПараметрыПоУмолчанию(ПараметрыПоиска.ПравилаПоиска, ПараметрыПоиска.КомпоновщикПредварительногоОтбора);
 		
		МенеджерОбластиПоиска.ПараметрыПоискаДублей(ПрикладныеПараметры, ДополнительныеПараметры);
		
		ВсеДополнительныеПоля = Новый Соответствие;
		Для Каждого Ограничение Из ПрикладныеПараметры.ОграниченияСравнения Цикл
			Для Каждого КлючЗначение Из Новый Структура(Ограничение.ДополнительныеПоля) Цикл
				ИмяПоля = КлючЗначение.Ключ;
				Если ВсеДополнительныеПоля[ИмяПоля] = Неопределено Тогда
					ПоляДополнительныхДанных = ПоляДополнительныхДанных + ", " + ИмяПоля;
					ВсеДополнительныеПоля[ИмяПоля] = Истина;
				КонецЕсли; 
			КонецЦикла;
		КонецЦикла;
		ПоляДополнительныхДанных = Сред(ПоляДополнительныхДанных, 2);
		
		// Сколько отдавать в прикладные правила для расчета
		РазмерПрикладнойПорции = ПрикладныеПараметры.КоличествоЭлементовДляСравнения;
	КонецЕсли;
	
	// Списки полей, возможно измененные прикладным кодом
	Для Каждого Строка Из ПараметрыПоиска.ПравилаПоиска Цикл
		Если Строка.Правило = "Равно" Тогда
			ПоляСравненияНаРавенство = ПоляСравненияНаРавенство + ", " + Строка.Реквизит;
		ИначеЕсли Строка.Правило = "Подобно" Тогда
			ПоляСравненияНаПодобие = ПоляСравненияНаПодобие + ", " + Строка.Реквизит;
		КонецЕсли
	КонецЦикла;
	ПоляСравненияНаРавенство = Сред(ПоляСравненияНаРавенство, 2);
	ПоляСравненияНаПодобие   = Сред(ПоляСравненияНаПодобие, 2);
	
	// 2. Конструируем по возможно измененному компоновщику условия отбора
	Фильтр = ФильтрПоискаПоКомпоновщику(ПараметрыПоиска.КомпоновщикПредварительногоОтбора);
	
	МетаданныеТаблицы = Метаданные.НайтиПоПолномуИмени(ПараметрыПоиска.ОбластьПоискаДублей);
	Характеристики= Новый Структура("ДлинаКода, ДлинаНаименования, Иерархический, ВидИерархии", 0, 0, Ложь);
	ЗаполнитьЗначенияСвойств(Характеристики, МетаданныеТаблицы);
	
	ЕстьНаименование = Характеристики.ДлинаНаименования > 0;
	ЕстьКод          = Характеристики.ДлинаКода > 0;
	
	Если Характеристики.Иерархический И Характеристики.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
		// Среди групп не ищем
		Если ПустаяСтрока(Фильтр.Текст) Тогда
			Фильтр.Текст = "НЕ ЭтоГруппа";
		Иначе
			Фильтр.Текст = "НЕ ЭтоГруппа И (" + Фильтр.Текст + ")";
		КонецЕсли;
	КонецЕсли;
	
	// Дополнительные поля могут пересекаться с остальными, им надо дать псевдонимы.
	ТаблицаКандидатов = Новый ТаблицаЗначений;
	КолонкиКандидатов = ТаблицаКандидатов.Колонки;
	КолонкиКандидатов.Добавить("Ссылка1");
	КолонкиКандидатов.Добавить("Поля1");
	КолонкиКандидатов.Добавить("Ссылка2");
	КолонкиКандидатов.Добавить("Поля2");
	КолонкиКандидатов.Добавить("ЭтоДубли", Новый ОписаниеТипов("Булево"));
	ТаблицаКандидатов.Индексы.Добавить("ЭтоДубли");
	
	РасшифровкаДополнительныхПолей = Новый Соответствие;
	ДополнительныеПсевдонимы  = "";
	ПорядковыйНомер = 0;
	Для Каждого КлючЗначение Из Новый Структура(ПоляДополнительныхДанных) Цикл
		ИмяПоля   = КлючЗначение.Ключ;
		Псевдоним = "Доп" + Формат(ПорядковыйНомер, "ЧН=; ЧГ=") + "_" + ИмяПоля;
		РасшифровкаДополнительныхПолей.Вставить(Псевдоним, ИмяПоля);
		
		ДополнительныеПсевдонимы = ДополнительныеПсевдонимы + "," + ИмяПоля + " КАК " + Псевдоним;
		ПорядковыйНомер = ПорядковыйНомер + 1;
	КонецЦикла;
	ДополнительныеПсевдонимы = Сред(ДополнительныеПсевдонимы, 2);
	
	// Одинаковые поля будут сравниваться по равенству
	СтруктураПолейИдентичности = Новый Структура(ПоляСравненияНаРавенство);
	УсловиеИдентичности  = "";
	Для Каждого КлючЗначение Из СтруктураПолейИдентичности Цикл
		ИмяПоля = КлючЗначение.Ключ;
		УсловиеИдентичности = УсловиеИдентичности + "И " + ИмяПоля + " = &" + ИмяПоля + " ";
	КонецЦикла;
	УсловиеИдентичности = Сред(УсловиеИдентичности, 2);
	
	СтруктураПолейПодобия = Новый Структура(ПоляСравненияНаПодобие);
	
	ОбщаяЧастьЗапроса = "
		|ВЫБРАТЬ 
		|	" + ?(ПустаяСтрока(ПоляСравненияНаРавенство), "", ПоляСравненияНаРавенство + "," ) + "
		|	" + ?(ПустаяСтрока(ПоляСравненияНаПодобие),   "", ПоляСравненияНаПодобие   + "," ) + "
		|	" + ?(ПустаяСтрока(ДополнительныеПсевдонимы), "", ДополнительныеПсевдонимы + "," ) + "
		|	Ссылка
		|";
	Если Не СтруктураПолейИдентичности.Свойство("Код") И Не СтруктураПолейПодобия.Свойство("Код") Тогда
		ОбщаяЧастьЗапроса = ОбщаяЧастьЗапроса + "," + ?(ЕстьКод, "Код", "НЕОПРЕДЕЛЕНО") + " КАК Код";
	КонецЕсли;
	Если Не СтруктураПолейИдентичности.Свойство("Наименование") И Не СтруктураПолейПодобия.Свойство("Наименование") Тогда
		ОбщаяЧастьЗапроса = ОбщаяЧастьЗапроса + "," + ?(ЕстьНаименование, "Наименование", "НЕОПРЕДЕЛЕНО") + " КАК Наименование";
	КонецЕсли;
	ОбщаяЧастьЗапроса = ОбщаяЧастьЗапроса + "
		|ИЗ
		|	" + ПараметрыПоиска.ОбластьПоискаДублей + "
		|";
	
	// Основной запрос - для каждого элемента будем искать кандидаты-дубли
	Если ЭталонныйОбъект = Неопределено Тогда
		
		Запрос = Новый Запрос(ОбщаяЧастьЗапроса + "
			|" + ?(ПустаяСтрока(Фильтр.Текст), "", "ГДЕ " + Фильтр.Текст) + "
			|УПОРЯДОЧИТЬ ПО
			|	Ссылка
			|");
	Иначе
		
		ТекстПредвыборки = "
			|ВЫБРАТЬ * ПОМЕСТИТЬ ЭталонныйОбъект ИЗ &_ЭталонныйОбъект КАК Эталон
			|;////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ 
			|	" + ?(ПустаяСтрока(ПоляСравненияНаРавенство), "", ПоляСравненияНаРавенство + "," ) + "
			|	" + ?(ПустаяСтрока(ПоляСравненияНаПодобие),   "", ПоляСравненияНаПодобие   + "," ) + "
			|	" + ?(ПустаяСтрока(ДополнительныеПсевдонимы), "", ДополнительныеПсевдонимы + "," ) + "
			|	ЗНАЧЕНИЕ(" + ПараметрыПоиска.ОбластьПоискаДублей + ".ПустаяСсылка) КАК Ссылка
			|";
		Если Не СтруктураПолейИдентичности.Свойство("Код") И Не СтруктураПолейПодобия.Свойство("Код") Тогда
			ТекстПредвыборки = ТекстПредвыборки + "," + ?(ЕстьКод, "Код", "НЕОПРЕДЕЛЕНО") + " КАК Код";
		КонецЕсли;
		Если Не СтруктураПолейИдентичности.Свойство("Наименование") И Не СтруктураПолейПодобия.Свойство("Наименование") Тогда
			ТекстПредвыборки = ТекстПредвыборки + "," + ?(ЕстьНаименование, "Наименование", "НЕОПРЕДЕЛЕНО") + " КАК Наименование";
		КонецЕсли;
		ТекстПредвыборки = ТекстПредвыборки + "
			|ИЗ
			|	ЭталонныйОбъект
			|";
		
		Запрос = Новый Запрос(ТекстПредвыборки + "
			|" + ?(ПустаяСтрока(Фильтр.Текст), "", "ГДЕ " + Фильтр.Текст) + "
			|");
			
		Запрос.УстановитьПараметр("_ЭталонныйОбъект", ОбъектВТаблицуЗначений(ЭталонныйОбъект));
	КонецЕсли;
		
		
	// Запрос поиска кандидатов к текущей ссылке. 
	// Сравнение ссылок и упорядочение в предыдущем запросе дают возможность избежать повторных сравнений
	ЗапросКандидатов = Новый Запрос(ОбщаяЧастьЗапроса + "
		|ГДЕ
		|	Ссылка > &_ИсходнаяСсылка
		|	" + ?(ПустаяСтрока(Фильтр.Текст), "", "И (" + Фильтр.Текст + ")") + "
		|	" + ?(ПустаяСтрока(УсловиеИдентичности), "", "И (" + УсловиеИдентичности+ ")") + "
		|");
		
	Для Каждого КлючЗначение Из Фильтр.Параметры Цикл
		ИмяПараметра      = КлючЗначение.Ключ;
		ЗначениеПараметра = КлючЗначение.Значение;
		Запрос.УстановитьПараметр(ИмяПараметра, ЗначениеПараметра);
		ЗапросКандидатов.УстановитьПараметр(ИмяПараметра, ЗначениеПараметра);
	КонецЦикла;
	
	// Результат и цикл поиска
	ТаблицаДублей = Новый ТаблицаЗначений;
	КолонкиРезультата = ТаблицаДублей.Колонки;
	КолонкиРезультата.Добавить("Ссылка");
	Для Каждого КлючЗначение Из СтруктураПолейИдентичности Цикл
		КолонкиРезультата.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	Для Каждого КлючЗначение Из СтруктураПолейПодобия Цикл
		КолонкиРезультата.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	Если КолонкиРезультата.Найти("Код") = Неопределено Тогда
		КолонкиРезультата.Добавить("Код");
	КонецЕсли;
	Если КолонкиРезультата.Найти("Наименование") = Неопределено Тогда
		КолонкиРезультата.Добавить("Наименование");
	КонецЕсли;
	КолонкиРезультата.Добавить("Родитель");
	
	ТаблицаДублей.Индексы.Добавить("Ссылка");
	ТаблицаДублей.Индексы.Добавить("Родитель");
	ТаблицаДублей.Индексы.Добавить("Ссылка, Родитель");
	
	Результат = Новый Структура("ТаблицаДублей, ОписаниеОшибки", ТаблицаДублей);
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("РасшифровкаДополнительныхПолей", РасшифровкаДополнительныхПолей);
	СтруктураПолей.Вставить("СтруктураПолейИдентичности",     СтруктураПолейИдентичности);
	СтруктураПолей.Вставить("СтруктураПолейПодобия",          СтруктураПолейПодобия);
	СтруктураПолей.Вставить("СписокПолейИдентичности",        ПоляСравненияНаРавенство);
	СтруктураПолей.Вставить("СписокПолейПодобия",             ПоляСравненияНаПодобие);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		// Отбираем похожих
		ЗапросКандидатов.УстановитьПараметр("_ИсходнаяСсылка", Выборка.Ссылка);
		Для Каждого КлючЗначение Из СтруктураПолейИдентичности Цикл
			ИмяПоля = КлючЗначение.Ключ;
			ЗапросКандидатов.УстановитьПараметр(ИмяПоля, Выборка[ИмяПоля]);
		КонецЦикла;
		
		ВыборкаКандидатов = ЗапросКандидатов.Выполнить().Выбрать();
		Пока ВыборкаКандидатов.Следующий() Цикл
			
			// Если мы его уже посчитали дублем в какой-то группе, то не трогаем
			Если ТаблицаДублей.Найти(ВыборкаКандидатов.Ссылка, "Ссылка") <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НеДубли = Ложь;
			
			// Проигрываем правила подобия для строк
			Для Каждого КлючЗначение Из СтруктураПолейПодобия Цикл
				ИмяПоля = КлючЗначение.Ключ;
				Если Не СтрокиПодобны(Выборка[ИмяПоля], ВыборкаКандидатов[ИмяПоля]) Тогда
					НеДубли = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НеДубли Тогда
				Продолжить;
			КонецЕсли;
			
			Если ИспользоватьПрикладныеПравила Тогда
				// Наполняем таблицу для прикладных правил, вызываем их, если пора
				ДобавитьСтрокуКандидатов(ТаблицаКандидатов, Выборка, ВыборкаКандидатов, СтруктураПолей);
				Если ТаблицаКандидатов.Количество() = РазмерПрикладнойПорции Тогда
					ДобавитьДублиПоПрикладнымПравилам(ТаблицаДублей, МенеджерОбластиПоиска, Выборка, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
					ТаблицаКандидатов.Очистить();
				КонецЕсли;
			Иначе
				ДобавитьДубльВРезультат(ТаблицаДублей, Выборка, ВыборкаКандидатов, СтруктураПолей);
			КонецЕсли;
			
		КонецЦикла;
		
		// Обрабатываем остаток таблицы для прикладных правил
		Если ИспользоватьПрикладныеПравила Тогда
			ДобавитьДублиПоПрикладнымПравилам(ТаблицаДублей, МенеджерОбластиПоиска, Выборка, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
			ТаблицаКандидатов.Очистить();
		КонецЕсли;
		
		// Завершен анализ группы, смотрим на количество. Много клиенту не отдаем.
		Если РазмерВозвращаемойПорции > 0 И (ТаблицаДублей.Количество() > РазмерВозвращаемойПорции) Тогда
			// Откатываем последнюю группу
			Для Каждого Строка Из ТаблицаДублей.НайтиСтроки( Новый Структура("Родитель ", Выборка.Ссылка) ) Цикл
				ТаблицаДублей.Удалить(Строка);
			КонецЦикла;
			Для Каждого Строка Из ТаблицаДублей.НайтиСтроки( Новый Структура("Ссылка", Выборка.Ссылка) ) Цикл
				ТаблицаДублей.Удалить(Строка);
			КонецЦикла;
			// Если это была последняя группа, то сообщаем об ошибке
			Если ТаблицаДублей.Количество() = 0 Тогда
				Результат.ОписаниеОшибки = НСтр("ru = 'Найдено слишком много элементов, определены не все группы дублей.'");
			Иначе
				Результат.ОписаниеОшибки = НСтр("ru = 'Найдено слишком много элементов. Уточните критерии поиска дублей.'");
			КонецЕсли;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Результат.ОписаниеОшибки <> Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Расчет мест использования
	Если РассчитыватьМестаИспользования Тогда
		НаборСсылок = Новый Массив;
		Для Каждого СтрокаДублей Из ТаблицаДублей Цикл
			Если ЗначениеЗаполнено(СтрокаДублей.Ссылка) Тогда
				НаборСсылок.Добавить(СтрокаДублей.Ссылка);
			КонецЕсли;
		КонецЦикла;
		
		МестаИспользования = МестаИспользованияСсылок(НаборСсылок);
		МестаИспользования = МестаИспользования.Скопировать(
			МестаИспользования.НайтиСтроки(Новый Структура("ВспомогательныеДанные", Ложь))
		);
		МестаИспользования.Индексы.Добавить("Ссылка");
		
		Результат.Вставить("МестаИспользования", МестаИспользования);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Определение наличия прикладных правил у объекта
//
// Параметры:
//     МенеджерОбласти - СправочникМенеджер - Менеджер проверяемого объекта
//
// Возвращаемое значение:
//     Булево - Истина, если прикладные правила определены
//
Функция ЕстьПрикладныеПравилаОбластиПоискаДублей(Знач МенеджерОбласти) Экспорт
	
	Попытка
		Результат = (Истина = МенеджерОбласти.ИспользоватьПоискДублей());
	Исключение
		// Нет метода или метод поломан. Считаем, что правил нет
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Преобразуем объект в таблицу для помещения в запрос
Функция ОбъектВТаблицуЗначений(Знач ОбъектДанных)
	Результат = Новый ТаблицаЗначений;
	СтрокаДанных = Результат.Добавить();
	
	МетаОбъект = ОбъектДанных.Метаданные();
	
	Для Каждого МетаРеквизит Из МетаОбъект.СтандартныеРеквизиты  Цикл
		Имя = МетаРеквизит.Имя;
		Результат.Колонки.Добавить(Имя, МетаРеквизит.Тип);
		СтрокаДанных[Имя] = ОбъектДанных[Имя];
	КонецЦикла;
	
	Для Каждого МетаРеквизит Из МетаОбъект.Реквизиты Цикл
		Имя = МетаРеквизит.Имя;
		Результат.Колонки.Добавить(Имя, МетаРеквизит.Тип);
		СтрокаДанных[Имя] = ОбъектДанных[Имя];
	КонецЦикла;
	
	Возврат Результат;
КонецФункции
	
// Дополнительный анализ кандидатов в дубли прикладном методом
//
Процедура ДобавитьДублиПоПрикладнымПравилам(СтрокиДереваРезультата, Знач МенеджерОбластиПоиска, Знач ОсновныеДанные, Знач ТаблицаКандидатов, Знач СтруктураПолей, Знач ДополнительныеПараметры)
	Если ТаблицаКандидатов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбластиПоиска.ПриПоискеДублей(ТаблицаКандидатов, ДополнительныеПараметры);
	
	Данные1 = Новый Структура;
	Данные2 = Новый Структура;
	
	Для Каждого ПараКандидатов Из ТаблицаКандидатов.НайтиСтроки(Новый Структура("ЭтоДубли", Истина)) Цикл
		Данные1.Вставить("Ссылка",       ПараКандидатов.Ссылка1);
		Данные1.Вставить("Код",          ПараКандидатов.Поля1.Код);
		Данные1.Вставить("Наименование", ПараКандидатов.Поля1.Наименование);
		
		Данные2.Вставить("Ссылка",       ПараКандидатов.Ссылка2);
		Данные2.Вставить("Код",          ПараКандидатов.Поля2.Код);
		Данные2.Вставить("Наименование", ПараКандидатов.Поля2.Наименование);
		
		Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейИдентичности Цикл
			ИмяПоля = КлючЗначение.Ключ;
			Данные1.Вставить(ИмяПоля, ПараКандидатов.Поля1[ИмяПоля]);
			Данные2.Вставить(ИмяПоля, ПараКандидатов.Поля2[ИмяПоля]);
		КонецЦикла;
		Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейПодобия Цикл
			ИмяПоля = КлючЗначение.Ключ;
			Данные1.Вставить(ИмяПоля, ПараКандидатов.Поля1[ИмяПоля]);
			Данные2.Вставить(ИмяПоля, ПараКандидатов.Поля2[ИмяПоля]);
		КонецЦикла;
		
		ДобавитьДубльВРезультат(СтрокиДереваРезультата, Данные1, Данные2, СтруктураПолей);
	КонецЦикла;
КонецПроцедуры

// Добавляем строку в таблицу кандидатов для прикладного метода
//
Функция ДобавитьСтрокуКандидатов(ТаблицаКандидатов, Знач ДанныеОсновногоЭлемента, Знач ДанныеКандидата, Знач СтруктураПолей)
	
	Строка = ТаблицаКандидатов.Добавить();
	Строка.ЭтоДубли = Ложь;
	Строка.Ссылка1  = ДанныеОсновногоЭлемента.Ссылка;
	Строка.Ссылка2  = ДанныеКандидата.Ссылка;
	
	Строка.Поля1 = Новый Структура("Код, Наименование", ДанныеОсновногоЭлемента.Код, ДанныеОсновногоЭлемента.Наименование);
	Строка.Поля2 = Новый Структура("Код, Наименование", ДанныеКандидата.Код, ДанныеКандидата.Наименование);
	
	Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейИдентичности Цикл
		ИмяПоля = КлючЗначение.Ключ;
		Строка.Поля1.Вставить(ИмяПоля, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяПоля, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейПодобия Цикл
		ИмяПоля = КлючЗначение.Ключ;
		Строка.Поля1.Вставить(ИмяПоля, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяПоля, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Для Каждого КлючЗначение Из СтруктураПолей.РасшифровкаДополнительныхПолей Цикл
		ИмяКолонки = КлючЗначение.Значение;
		ИмяПоля    = КлючЗначение.Ключ;
		
		Строка.Поля1.Вставить(ИмяКолонки, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяКолонки, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Возврат Строка;
КонецФункции

// Добавляем в дерево результатов найденный вариант
//
Процедура ДобавитьДубльВРезультат(Результат, Знач ДанныеОсновногоЭлемента, Знач ДанныеКандидата, Знач СтруктураПолей)
	
	ФильтрГруппы = Новый Структура("Ссылка, Родитель", ДанныеОсновногоЭлемента.Ссылка);
	ГруппаДублей = Результат.НайтиСтроки(ФильтрГруппы);
	
	Если ГруппаДублей.Количество() = 0 Тогда
		ГруппаДублей = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(ГруппаДублей, ФильтрГруппы);
		
		СтрокаДублей = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДублей, ДанныеОсновногоЭлемента, 
			"Ссылка, Код, Наименование," + СтруктураПолей.СписокПолейИдентичности + "," + СтруктураПолей.СписокПолейПодобия
		);
		
		СтрокаДублей.Родитель = ГруппаДублей.Ссылка;
	Иначе
		ГруппаДублей = ГруппаДублей[0];
	КонецЕсли;
	
	СтрокаДублей = Результат.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаДублей, ДанныеКандидата, 
		"Ссылка, Код, Наименование," + СтруктураПолей.СписокПолейИдентичности + "," + СтруктураПолей.СписокПолейПодобия
	);
	
	СтрокаДублей.Родитель = ГруппаДублей.Ссылка;
КонецПроцедуры

// Формируем текст условия запроса и набор параметров
//
Функция ФильтрПоискаПоКомпоновщику(Знач КомпоновщикОтбора)
	Результат = Новый Структура("Параметры", Новый Структура);
	
	СтекГрупп = Новый Массив;
	СтекГрупп.Вставить(0, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	Результат.Вставить("Текст", ТекстОтбораГруппыКомпоновщика(КомпоновщикОтбора.Настройки.Отбор.Элементы, СтекГрупп, Результат.Параметры) );
	Результат.Вставить("Описание", Строка(КомпоновщикОтбора.Настройки.Отбор) );
	
	Возврат Результат;
КонецФункции

// Формируем текст для использования в запросе, заполняем параметры
//
Функция ТекстОтбораГруппыКомпоновщика(Знач ЭлементыГруппы, СтекГрупп, ПараметрыКомпоновщика)
	КоличествоЭлементов = ЭлементыГруппы.Количество();
	
	Если КоличествоЭлементов = 0 Тогда
		// Пустая группа условий
		Возврат "";
	КонецЕсли;
	
	ТипТекущейГруппы = СтекГрупп[0];
	
	Текст = "";
	ТокенСравнения = ТокенСравненияГруппыОтбораКомпоновки(ТипТекущейГруппы);
	
	Для Каждого Элемент Из ЭлементыГруппы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			// Одиночный элемент
			ИмяПараметра  = "ПараметрОтбора" + Формат(ПараметрыКомпоновщика.Количество(), "ЧН=; ЧГ=");
			
			ПоискПоПодобию = Ложь;
			Текст = Текст + " " + ТокенСравнения + " " + ТекстСравненияГруппыОтбораКомпоновки(Элемент.ЛевоеЗначение, Элемент.ВидСравнения, "&" + ИмяПараметра, ПоискПоПодобию);
			
			Если ПоискПоПодобию Тогда
				ПараметрыКомпоновщика.Вставить(ИмяПараметра, "%" + Элемент.ПравоеЗначение + "%");
			Иначе
				ПараметрыКомпоновщика.Вставить(ИмяПараметра, Элемент.ПравоеЗначение);
			КонецЕсли;
		Иначе
			// Вложенная группа
			СтекГрупп.Вставить(0, Элемент.ТипГруппы);
			Текст = Текст + " " + ТокенСравнения + " " + ТекстОтбораГруппыКомпоновщика(Элемент.Элементы, СтекГрупп, ПараметрыКомпоновщика);
			СтекГрупп.Удалить(0);
		КонецЕсли;
		
	КонецЦикла;
	
	Текст = Сред(Текст, 2 + СтрДлина(ТокенСравнения));
	Возврат ТокенОткрытияГруппыОтбораКомпоновки(ТипТекущейГруппы) 
		+ "(" + Текст + ")";
КонецФункции

// Токен сравнения элементов внутри группы
//
Функция ТокенСравненияГруппыОтбораКомпоновки(Знач ТипГруппы)
	
	Если ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ Тогда 
		Возврат "И";
		
	ИначеЕсли ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли Тогда 
		Возврат "ИЛИ";
		
	ИначеЕсли ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
		Возврат "И";
		
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Токен операции перед группой
//
Функция ТокенОткрытияГруппыОтбораКомпоновки(Знач ТипГруппы)
	
	Если ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
		Возврат "НЕ"
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Текст сравнения двух операндов по виду сравнения
//
Функция ТекстСравненияГруппыОтбораКомпоновки(Знач Поле, Знач ВидСравнения, Знач ИмяПараметра, ИспользованПоискПоПодобию = Ложь)
	
	ИспользованПоискПоПодобию = Ложь;
	ПолеСравнения             = Строка(Поле);
	
	Если ВидСравнения = ВидСравненияКомпоновкиДанных.Больше Тогда
		Возврат ПолеСравнения + " > " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно Тогда
		Возврат ПолеСравнения + " >= " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии Тогда
		Возврат ПолеСравнения + " В ИЕРАРХИИ (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
		Возврат ПолеСравнения + " В (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии  Тогда
		Возврат ПолеСравнения + " В ИЕРАРХИИ (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено Тогда
		ИспользованПоискПоПодобию = Истина;
		Возврат ПолеСравнения + " НЕ ПОДОБНО """" ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше Тогда
		Возврат ПолеСравнения + " < " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно Тогда
		Возврат ПолеСравнения + " <= " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии Тогда
		Возврат ПолеСравнения + " НЕ В ИЕРАРХИИ (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
		Возврат ПолеСравнения + " НЕ В (" + ИмяПараметра + ")";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		Возврат ПолеСравнения + " НЕ В ИЕРАРХИИ (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено Тогда
		ИспользованПоискПоПодобию = Истина;
		Возврат ПолеСравнения + " ПОДОБНО """" ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
		Возврат ПолеСравнения + " <> " + ИмяПараметра + " ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеСодержит Тогда
		ИспользованПоискПоПодобию = Истина;
		Возврат ПолеСравнения + " НЕ ПОДОБНО " + ИмяПараметра + " ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
		Возврат ПолеСравнения + " = " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит Тогда
		ИспользованПоискПоПодобию = Истина;
		Возврат ПолеСравнения + " ПОДОБНО " + ИмяПараметра + " ";;
		
	КонецЕсли;
	
	Возврат "";
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Нечеткое сравнение строк
//

Функция СтрокиПодобны(Знач Строка1, Знач Строка2)
	
	Возврат ПроцентПодобияСтрок(Строка1, Строка2) >= 90;
	
КонецФункции

// Возвращает процент похожести: 0 - не похоже, 100 - полное совпадение для строк
//
Функция ПроцентПодобияСтрок(Знач Строка1, Знач Строка2) Экспорт
	Если Строка1 = Строка2 Тогда
		Возврат 100;
	КонецЕсли;
	
	ВсеСлова = Новый Соответствие;
	ВхожденияСлов(ВсеСлова, Строка1, 1);
	ВхожденияСлов(ВсеСлова, Строка2, 2);
	
	// Только различные слова
	Сортировщик1 = Новый СписокЗначений;
	Сортировщик2 = Новый СписокЗначений;
	Для Каждого КлючЗначение Из ВсеСлова Цикл
		Если КлючЗначение.Значение = 1 Тогда
			Сортировщик1.Добавить(КлючЗначение.Ключ);
		ИначеЕсли КлючЗначение.Значение = 2 Тогда
			Сортировщик2.Добавить(КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	ПерваяСтрока = СловаИзСписка(Сортировщик1);
	ВтораяСтрока = СловаИзСписка(Сортировщик2);
	Если ПерваяСтрока = ВтораяСтрока Тогда 
		Возврат 100;
	КонецЕсли;
	
	Метрика = МетрикаРедактирования(ПерваяСтрока, ВтораяСтрока);
	
	Возврат 100 - Метрика * 100 / Макс(СтрДлина(Строка1), СтрДлина(Строка2))
КонецФункции

Процедура ВхожденияСлов(Результат, Знач ИсходнаяСтрока, Знач Приращение)
	
	РабочаяСтрока = СокрЛП(ИсходнаяСтрока);
	Пока Истина Цикл
		Позиция = Найти(РабочаяСтрока, " ");
		Если Позиция = 0 Тогда 
			Прервать;
		КонецЕсли;
		
		ТекущаяСтрока = Лев(РабочаяСтрока, Позиция - 1);
		Если Не ПустаяСтрока(ТекущаяСтрока) Тогда
			Значение = Результат[ТекущаяСтрока];
			Если Значение = Неопределено Тогда
				Значение = 0;
			КонецЕсли;
			Результат.Вставить(ТекущаяСтрока, Значение + Приращение);
		КонецЕсли;
		
		РабочаяСтрока = Сред(РабочаяСтрока, Позиция + 1);
	КонецЦикла;
	
	Если Не ПустаяСтрока(РабочаяСтрока) Тогда
		Значение = Результат[РабочаяСтрока];
		Если Значение = Неопределено Тогда
			Значение = 0;
		КонецЕсли;
		Результат.Вставить(РабочаяСтрока, Значение + Приращение);
	КонецЕсли;
	
КонецПроцедуры

Функция СловаИзСписка(Знач СписокСлов)
	Результат = "";
	
	СписокСлов.СортироватьПоЗначению();
	Для Каждого Элемент Из СписокСлов Цикл
		Результат = Результат + " " + Элемент.Значение;
	КонецЦикла;
	
	Возврат Сред(Результат, 2);
КонецФункции

Функция МетрикаРедактирования(Знач Строка1, Знач Строка2)
	Если Строка1 = Строка2 Тогда
		Возврат 0;
	КонецЕсли;
	
	Длина1 = СтрДлина(Строка1);
	Длина2 = СтрДлина(Строка2);
	
	Если Длина1 = 0 Тогда
		Если Длина2 = 0 Тогда
			Возврат 0;
		КонецЕсли;
		Возврат Длина2;
		
	ИначеЕсли Длина2 = "" Тогда
		Возврат Длина1;
		
	КонецЕсли;
	
	// Инициализация
	Коэффициенты = Новый Массив(Длина1 + 1, Длина2 + 1);
	Для Позиция1 = 0 По Длина1 Цикл
		Коэффициенты[Позиция1][0] = Позиция1;
	КонецЦикла;
	Для Позиция2 = 0 По Длина2 Цикл
		Коэффициенты[0][Позиция2] = Позиция2
	КонецЦикла;
	
	// Расчет
	Для Позиция1 = 1 По Длина1 Цикл
		ПредПозиция1 = Позиция1 - 1;
		Символ1      = Сред(Строка1, Позиция1, 1);
		
		Для Позиция2 = 1 По Длина2 Цикл
			ПредПозиция2 = Позиция2 - 1;
			Символ2      = Сред(Строка2, Позиция2, 1);
			
			Стоимость = ?(Символ1 = Символ2, 0, 1); // Стоимость замены
			
			Коэффициенты[Позиция1][Позиция2] = Мин(
				Коэффициенты[ПредПозиция1][Позиция2]     + 1,	// Стоимость удаления,
				Коэффициенты[Позиция1]    [ПредПозиция2] + 1,	// Стоимость вставки,
				Коэффициенты[ПредПозиция1][ПредПозиция2] + Стоимость
			);
			
			Если Позиция1 > 1 И Позиция2 > 1 И Символ1 = Сред(Строка2, ПредПозиция2, 1) И Сред(Строка1, ПредПозиция1, 1) = Символ2 Тогда
				Коэффициенты[Позиция1][Позиция2] = Мин(
					Коэффициенты[Позиция1][Позиция2],
					Коэффициенты[Позиция1 - 2][Позиция2 - 2] + Стоимость	// Стоимость перестановки
				);
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат Коэффициенты[Длина1][Длина2];
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Процедура ГруппаОбластейПоискаДублей(Результат, Знач АнализироватьПрикладныеПравила, Знач МенеджерГруппы, Знач Пиктограмма)
	
	Для Каждого Элемент Из МенеджерГруппы Цикл
		Мета = Метаданные.НайтиПоТипу(ТипЗнч(Элемент));
		Если Не ПравоДоступа("Чтение", Мета) Тогда
			// Нет доступа, не отражаем в списке
			Продолжить;
		КонецЕсли;
		
		Если АнализироватьПрикладныеПравила Тогда
			ЕстьПрикладныеПравила = ЕстьПрикладныеПравилаОбластиПоискаДублей( МенеджерГруппы[Мета.Имя] );
		Иначе
			ЕстьПрикладныеПравила = Ложь;
		КонецЕсли;
		
		Результат.Добавить(Мета.ПолноеИмя(), Строка(Мета), ЕстьПрикладныеПравила, БиблиотекаКартинок[Пиктограмма]);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Копия функционала
//

// [ОбщегоНазначения.МестаИспользования]
Функция МестаИспользованияСсылок(Знач НаборСсылок, Знач АдресРезультата = "")
	
	Возврат ОбщегоНазначения.МестаИспользования(НаборСсылок, АдресРезультата);
	
КонецФункции

// [ОбщегоНазначения.ЗаменитьСсылки]
Функция ЗаменитьСсылки(Знач ПарыЗамен, Знач Параметры = Неопределено, Знач АдресРезультата = "")
	
	Возврат ОбщегоНазначения.ЗаменитьСсылки(ПарыЗамен, Параметры, АдресРезультата);
	
КонецФункции

#КонецОбласти


#КонецЕсли