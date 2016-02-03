﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     - если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//  СокращатьНепечатаемыеСимволы - Булево - сокращать непечатаемые символы по краям каждой из найденных подстрок.
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Примеры:
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",") - возвратит массив из 5 элементов, три из которых  - пустые строки;
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина) - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок(" один   два  ", " ") - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок("") - возвратит пустой массив;
//  РазложитьСтрокуВМассивПодстрок("",,Ложь) - возвратит массив с одним элементом "" (пустой строкой);
//  РазложитьСтрокуВМассивПодстрок("", " ") - возвратит массив с одним элементом "" (пустой строкой);
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Результат = Новый Массив;
	
	// для обеспечения обратной совместимости
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Строка));
		Иначе
			Результат.Добавить(Строка);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

/// Объединяет строки из массива в строку с разделителями.
//
// Параметры:
//  Массив      - Массив - массив строк которые необходимо объединить в одну строку;
//  Разделитель - Строка - любой набор символов, который будет использован в качестве разделителя.
//
// Возвращаемое значение:
//  Строка - строка с разделителями.
// 
Функция СтрокаИзМассиваПодстрок(Массив, Разделитель = ",", СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Результат = "";
	
	Для Индекс = 0 По Массив.ВГраница() Цикл
		Подстрока = Массив[Индекс];
		
		Если СокращатьНепечатаемыеСимволы Тогда
			Подстрока = СокрЛП(Подстрока);
		КонецЕсли;
		
		Если ТипЗнч(Подстрока) <> Тип("Строка") Тогда
			Подстрока = Строка(Подстрока);
		КонецЕсли;
		
		Если Индекс > 0 Тогда
			Результат = Результат + Разделитель;
		КонецЕсли;
		
		Результат = Результат + Подстрока;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Определяет, является ли символ разделителем.
//
// Параметры:
//  КодСимвола      - Число  - код проверяемого символа;
//  РазделителиСлов - Строка - символы разделителей.
//
// Возвращаемое значение:
//  Булево - истина, если символ является разделителем.
//
Функция ЭтоРазделительСлов(КодСимвола, РазделителиСлов = Неопределено) Экспорт
	
	Если РазделителиСлов <> Неопределено Тогда
		Возврат Найти(РазделителиСлов, Символ(КодСимвола)) > 0;
	КонецЕсли;
		
	Диапазоны = Новый Массив;
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 48, 57)); 		// цифры
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 65, 90)); 		// латиница большие
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 97, 122)); 		// латиница маленькие
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 1040, 1103)); 	// кириллица
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 1025, 1025)); 	// символ "Ё"
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 1105, 1105)); 	// символ "ё"
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 95, 95)); 		// символ "_"
	
	Для Каждого Диапазон Из Диапазоны Цикл
		Если КодСимвола >= Диапазон.Мин И КодСимвола <= Диапазон.Макс Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Разбивает строку на несколько строк, используя заданный набор разделителей.
// Если параметр РазделителиСлов не задан, то разделителем слов считается любой из символов, 
// не относящихся к символам латиницы, кириллицы, цифры, подчеркивания.
//
// Параметры:
//  Строка          - Строка - строка, которую необходимо разложить на слова.
//  РазделителиСлов - Строка - строка, содержащая символы-разделители.
//
//  Возвращаемое значение:
//      массив значений, элементы которого - отдельные слова
//
// Пример:
//  РазложитьСтрокуВМассивСлов("один-@#два2_!три") возвратит массив значений: "один", "два2_", "три";
//  РазложитьСтрокуВМассивСлов("один-@#два2_!три", "#@!_") возвратит массив значений: "один-", "два2", "три".
//
Функция РазложитьСтрокуВМассивСлов(Знач Строка, РазделителиСлов = Неопределено) Экспорт
	
	Слова = Новый Массив;
	
	РазмерТекста = СтрДлина(Строка);
	НачалоСлова = 1;
	Для Позиция = 1 По РазмерТекста Цикл
		КодСимвола = КодСимвола(Строка, Позиция);
		Если ЭтоРазделительСлов(КодСимвола, РазделителиСлов) Тогда
			Если Позиция <> НачалоСлова Тогда
				Слова.Добавить(Сред(Строка, НачалоСлова, Позиция - НачалоСлова));
			КонецЕсли;
			НачалоСлова = Позиция + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если Позиция <> НачалоСлова Тогда
		Слова.Добавить(Сред(Строка, НачалоСлова, Позиция - НачалоСлова));
	КонецЕсли;
	
	Возврат Слова;
	
КонецФункции

// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  СтрокаПодстановки  - Строка - шаблон строки с параметрами (вхождениями вида "%ИмяПараметра");
//  Параметр<n>        - Строка - подставляемый параметр.
//
// Возвращаемое значение:
//  Строка   - текстовая строка с подставленными параметрами.
//
// Пример:
//  ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк") = "Вася пошел в Зоопарк".
//
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	ИспользоватьАльтернативныйАлгоритм = 
		Найти(Параметр1, "%")
		Или Найти(Параметр2, "%")
		Или Найти(Параметр3, "%")
		Или Найти(Параметр4, "%")
		Или Найти(Параметр5, "%")
		Или Найти(Параметр6, "%")
		Или Найти(Параметр7, "%")
		Или Найти(Параметр8, "%")
		Или Найти(Параметр9, "%");
		
	Если ИспользоватьАльтернативныйАлгоритм Тогда
		СтрокаПодстановки = ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(СтрокаПодстановки, Параметр1,
			Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	Иначе
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%4", Параметр4);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%5", Параметр5);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%6", Параметр6);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%7", Параметр7);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%8", Параметр8);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%9", Параметр9);
	КонецЕсли;
	
	Возврат СтрокаПодстановки;
КонецФункции

// Подставляет параметры в строку. Число параметров в строке не ограничено.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров
// начинается с единицы.
//
// Параметры
//  СтрокаПодстановки  - Строка - шаблон строки с параметрами (вхождениями вида "%1");
//  МассивПараметров   - Массив - массив строк, которые соответствуют параметрам в строке подстановки.
//
// Возвращаемое значение:
//   Строка - строка с подставленными параметрами.
//
// Пример:
//  МассивПараметров = Новый Массив;
//  МассивПараметров = МассивПараметров.Добавить("Вася");
//  МассивПараметров = МассивПараметров.Добавить("Зоопарк");
//
//  Строка = ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), МассивПараметров);
//
Функция ПодставитьПараметрыВСтрокуИзМассива(Знач СтрокаПодстановки, Знач МассивПараметров) Экспорт
	
	СтрокаРезультата = СтрокаПодстановки;
	
	Индекс = МассивПараметров.Количество();
	Пока Индекс > 0 Цикл
		Значение = МассивПараметров[Индекс-1];
		Если Не ПустаяСтрока(Значение) Тогда
			СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%" + Формат(Индекс, "ЧГ="), Значение);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Возврат СтрокаРезультата;
	
КонецФункции

// Заменяет в шаблоне строки имена параметров на их значения. Параметры в строке выделяются с двух сторон квадратными скобками.
//
// Параметры:
//
//  ШаблонСтроки        - Строка    - строка, в которую необходимо вставить значения.
//  ВставляемыеЗначения - Структура - структура значений, где ключ - имя параметра без спецсимволов,
//                                    значение - вставляемое значение.
//
// Возвращаемое значение:
//  Строка - строка со вставленными значениями.
//
// Пример использования:
//  ВставитьПараметрыВСтроку("Здравствуй, [Имя] [Фамилия].", Новый Структура("Фамилия,Имя", "Пупкин", "Вася"));
//  Возвращает: "Здравствуй, Вася Пупкин".
Функция ВставитьПараметрыВСтроку(Знач ШаблонСтроки, ВставляемыеЗначения) Экспорт
	Результат = ШаблонСтроки;
	Для Каждого Параметр Из ВставляемыеЗначения Цикл
		Результат = СтрЗаменить(Результат, "[" + Параметр.Ключ + "]", Параметр.Значение);
	КонецЦикла;
	Возврат Результат;
КонецФункции

// Получает значения параметров из строки.
//
// Параметры:
//  СтрокаПараметров - Строка - строка, содержащая параметры, каждый из которых представляет собой
//                              фрагмент вида <Имя параметра>=<Значение>, где:
//                                Имя параметра - имя параметра; 
//                                Значение - его значение. 
//                              Фрагменты отделяются друг от друга символами ';'.
//                              Если значение содержит пробельные символы, то оно должно быть заключено в двойные кавычки (").
//                              Например:
//                               "File=""c:\InfoBases\Trade""; Usr=""Director"";"
//
// Возвращаемое значение:
//  Структура - структура параметров, где ключ - имя параметра, значение - значение параметра.
//
Функция ПолучитьПараметрыИзСтроки(Знач СтрокаПараметров) Экспорт
	
	Результат = Новый Структура;
	
	СимволДвойныеКавычки = Символ(34); // (")
	
	МассивПодстрок = РазложитьСтрокуВМассивПодстрок(СтрокаПараметров, ";");
	
	Для Каждого СтрокаПараметра Из МассивПодстрок Цикл
		
		ПозицияПервогоЗнакаРавенства = Найти(СтрокаПараметра, "=");
		
		// Получаем имя параметра
		ИмяПараметра = СокрЛП(Лев(СтрокаПараметра, ПозицияПервогоЗнакаРавенства - 1));
		
		// Получаем значение параметра
		ЗначениеПараметра = СокрЛП(Сред(СтрокаПараметра, ПозицияПервогоЗнакаРавенства + 1));
		
		Если  Лев(ЗначениеПараметра, 1) = СимволДвойныеКавычки
			И Прав(ЗначениеПараметра, 1) = СимволДвойныеКавычки Тогда
			
			ЗначениеПараметра = Сред(ЗначениеПараметра, 2, СтрДлина(ЗначениеПараметра) - 2);
			
		КонецЕсли;
		
		Если Не ПустаяСтрока(ИмяПараметра) Тогда
			
			Результат.Вставить(ИмяПараметра, ЗначениеПараметра);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Проверяет, содержит ли строка только цифры.
//
// Параметры:
//  СтрокаПроверки          - Строка - Строка для проверки
//  УчитыватьЛидирующиеНули - Булево - Флаг учета лидирующих нулей, если Истина, то ведущие нули пропускаются
//  УчитыватьПробелы        - Булево - Флаг учета пробелов, если Истина, то пробелы при проверке игнорируются
//
// Возвращаемое значение:
//   Булево - Истина - строка содержит только цифры или пустая, Ложь - строка содержит иные символы.
//
Функция ТолькоЦифрыВСтроке(Знач СтрокаПроверки, Знач УчитыватьЛидирующиеНули = Истина, Знач УчитыватьПробелы = Истина) Экспорт
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не УчитыватьПробелы Тогда
		СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
	КонецЕсли;
		
	Если ПустаяСтрока(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не УчитыватьЛидирующиеНули Тогда
		Позиция = 1;
		// Взятие символа за границей строки возвращает пустую строку
		Пока Сред(СтрокаПроверки, Позиция, 1) = "0" Цикл
			Позиция = Позиция + 1;
		КонецЦикла;
		СтрокаПроверки = Сред(СтрокаПроверки, Позиция);
	КонецЕсли;
	
	// Если содержит только цифры, то в результате замен должна быть получена пустая строка
	// Проверять при помощи ПустаяСтрока нельзя, так как в исходной строке могут быть пробельные символы
	Возврат СтрДлина(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( 
			СтрокаПроверки, "0", ""), "1", ""), "2", ""), "3", ""), "4", ""), "5", ""), "6", ""), "7", ""), "8", ""), "9", "")
	) = 0;
	
КонецФункции

// Проверяет, содержит ли строка только символы кириллического алфавита.
//
// Параметры:
//  УчитыватьРазделителиСлов - Булево - учитывать ли разделители слов или они являются исключением.
//  ДопустимыеСимволы - строка для проверки.
//
// Возвращаемое значение:
//  Булево - Истина, если строка содержит только кириллические (или допустимые) символы или пустая;
//           Ложь, если строка содержит иные символы.
//
Функция ТолькоКириллицаВСтроке(Знач СтрокаПроверки, Знач УчитыватьРазделителиСлов = Истина, ДопустимыеСимволы = "") Экспорт
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	КодыДопустимыхСимволов = Новый Массив;
	КодыДопустимыхСимволов.Добавить(1105); // "ё"
	КодыДопустимыхСимволов.Добавить(1025); // "Ё"
	
	Для а = 1 По СтрДлина(ДопустимыеСимволы) Цикл
		КодыДопустимыхСимволов.Добавить(КодСимвола(Сред(ДопустимыеСимволы, а, 1)));
	КонецЦикла;
	
	Для а = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, а, 1));
		Если ((КодСимвола < 1040) Или (КодСимвола > 1103)) 
			И (КодыДопустимыхСимволов.Найти(КодСимвола) = Неопределено) 
			И Не (Не УчитыватьРазделителиСлов И ЭтоРазделительСлов(КодСимвола)) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Проверяет, содержит ли строка только символы латинского алфавита.
//
// Параметры:
//  УчитыватьРазделителиСлов - Булево - учитывать ли разделители слов или они являются исключением.
//  ДопустимыеСимволы - строка для проверки.
//
// Возвращаемое значение:
//  Булево - Истина, если строка содержит только латинские (или допустимые) символы;
//         - Ложь, если строка содержит иные символы.
//
Функция ТолькоЛатиницаВСтроке(Знач СтрокаПроверки, Знач УчитыватьРазделителиСлов = Истина, ДопустимыеСимволы = "") Экспорт
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	КодыДопустимыхСимволов = Новый Массив;
	
	Для а = 1 По СтрДлина(ДопустимыеСимволы) Цикл
		КодыДопустимыхСимволов.Добавить(КодСимвола(Сред(ДопустимыеСимволы, а, 1)));
	КонецЦикла;
	
	Для а = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, а, 1));
		Если ((КодСимвола < 65) Или (КодСимвола > 90 И КодСимвола < 97) Или (КодСимвола > 122))
			И (КодыДопустимыхСимволов.Найти(КодСимвола) = Неопределено) 
			И Не (Не УчитыватьРазделителиСлов И ЭтоРазделительСлов(КодСимвола)) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Удаляет двойные кавычки с начала и конца строки, если они есть.
//
// Параметры:
//  Строка - входная строка;
//
// Возвращаемое значение:
//  Строка - строка без двойных кавычек.
// 
Функция СократитьДвойныеКавычки(Знач Строка) Экспорт
	
	Пока Лев(Строка, 1) = """" Цикл
		Строка = Сред(Строка, 2); 
	КонецЦикла; 
	
	Пока Прав(Строка, 1) = """" Цикл
		Строка = Лев(Строка, СтрДлина(Строка) - 1);
	КонецЦикла;
	
	Возврат Строка;
	
КонецФункции 

// Удаляет из строки указанное количество символов справа.
//
// Параметры:
//  Текст         - Строка - строка, в которой необходимо удалить последние символы;
//  ЧислоСимволов - Число  - количество удаляемых символов.
//
Процедура УдалитьПоследнийСимволВСтроке(Текст, ЧислоСимволов = 1) Экспорт
	
	Текст = Лев(Текст, СтрДлина(Текст) - ЧислоСимволов);
	
КонецПроцедуры 

// Осуществляет поиск символа, начиная с конца строки.
//
// Параметры:
//  Строка - Строка - строка, в которой осуществляется поиск;
//  Символ - Строка - искомый символ. Допускается искать строку, содержащую более одного символа.
//
// Возвращаемое значение:
//  Число - позиция символа в строке. 
//          Если строка не содержит указанного символа, то возвращается 0.
//
Функция НайтиСимволСКонца(Знач Строка, Знач Символ) Экспорт
	
	Для Позиция = -СтрДлина(Строка) По -1 Цикл
		Если Сред(Строка, -Позиция, СтрДлина(Символ)) = Символ Тогда
			Возврат -Позиция;
		КонецЕсли;
	КонецЦикла;
	
	Возврат 0;
		
КонецФункции

// Проверяет, является ли строка уникальным идентификатором.
// В качестве уникального идентификатора предполагается строка вида
// "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX", где X = [0..9,a..f].
//
// Параметры:
//  ИдентификаторСтрока - Строка - проверяемая строка.
//
// Возвращаемое значение:
//  Булево - Истина, если переданная строка является уникальным идентификатором.
Функция ЭтоУникальныйИдентификатор(Знач Строка) Экспорт
	
	Шаблон = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
	
	Если СтрДлина(Шаблон) <> СтрДлина(Строка) Тогда
		Возврат Ложь;
	КонецЕсли;
	Для Позиция = 1 По СтрДлина(Строка) Цикл
		Если КодСимвола(Шаблон, Позиция) = 88 // X
			И ((КодСимвола(Строка, Позиция) < 48 Или КодСимвола(Строка, Позиция) > 57) // 0..9
			И (КодСимвола(Строка, Позиция) < 97 Или КодСимвола(Строка, Позиция) > 102) // a..f
			И (КодСимвола(Строка, Позиция) < 65 Или КодСимвола(Строка, Позиция) > 70)) // A..F
			Или КодСимвола(Шаблон, Позиция) = 45 И КодСимвола(Строка, Позиция) <> 45 Тогда // -
				Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;

КонецФункции

// Формирует строку повторяющихся символов заданной длины.
//
// Параметры:
//  Символ      - Строка - символ, из которого будет формироваться строка.
//  ДлинаСтроки - Число  - требуемая длина результирующей строки.
//
// Возвращаемое значение:
//  Строка - строка, состоящая из повторяющихся символов.
//
Функция СформироватьСтрокуСимволов(Знач Символ, Знач ДлинаСтроки) Экспорт
	
	Результат = "";
	Для Счетчик = 1 По ДлинаСтроки Цикл
		Результат = Результат + Символ;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Дополняет строку символами слева или справа до заданной длины и возвращает ее.
// Незначащие символы слева и справа удаляются. По умолчанию функция дополняет строку символами "0" (ноль) слева.
//
// Параметры:
//  Строка      - Строка - исходная строка, которую необходимо дополнить символами;
//  ДлинаСтроки - Число  - требуемая результирующая длина строки;
//  Символ      - Строка - символ, которым необходимо дополнить строку;
//  Режим       - Строка - "Слева" или "Справа" - режим добавления символов к исходной строке.
// 
// Возвращаемое значение:
//  Строка - строка, дополненная символами.
//
// Пример 1:
// Строка = "1234"; ДлинаСтроки = 10; Символ = "0"; Режим = "Слева"
// Возврат: "0000001234"
//
// Пример 2:
// Строка = " 1234  "; ДлинаСтроки = 10; Символ = "#"; Режим = "Справа"
// Возврат: "1234######"
//
Функция ДополнитьСтроку(Знач Строка, Знач ДлинаСтроки, Знач Символ = "0", Знач Режим = "Слева") Экспорт
	
	// длина символа не должна превышать единицы
	Символ = Лев(Символ, 1);
	
	// удаляем крайние пробелы слева и справа строки
	Строка = СокрЛП(Строка);
	
	КоличествоСимволовНадоДобавить = ДлинаСтроки - СтрДлина(Строка);
	
	Если КоличествоСимволовНадоДобавить > 0 Тогда
		
		СтрокаДляДобавления = СформироватьСтрокуСимволов(Символ, КоличествоСимволовНадоДобавить);
		
		Если ВРег(Режим) = "СЛЕВА" Тогда
			
			Строка = СтрокаДляДобавления + Строка;
			
		ИначеЕсли ВРег(Режим) = "СПРАВА" Тогда
			
			Строка = Строка + СтрокаДляДобавления;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

// Удаляет крайние повторяющиеся символы слева или справа в строке.
//
// Параметры:
//  Строка      - Строка - исходная строка, из которой необходимо удалить крайние повторяющиеся символы;
//  Символ      - Строка - искомый символ для удаления;
//  Режим       - Строка - "Слева" или "Справа" - режим удаления символов в исходной строке.
//
// Возвращаемое значение:
//  Строка - обрезанная строка.
//
Функция УдалитьПовторяющиесяСимволы(Знач Строка, Знач Символ, Знач Режим = "Слева") Экспорт
	
	Если ВРег(Режим) = "СЛЕВА" Тогда
		
		Пока Лев(Строка, 1)= Символ Цикл
			
			Строка = Сред(Строка, 2);
			
		КонецЦикла;
		
	ИначеЕсли ВРег(Режим) = "СПРАВА" Тогда
		
		Пока Прав(Строка, 1)= Символ Цикл
			
			Строка = Лев(Строка, СтрДлина(Строка) - 1);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Строка;
КонецФункции

// Выполняет замену символов в строке.
//
// Параметры:
//  ЗаменяемыеСимволы - Строка - строка символов, каждый из которых требует замены;
//  Строка            - Строка - исходная строка, в которой требуется замена символов;
//  СимволыЗамены     - Строка - строка символов, на каждый из которых нужно заменить символы параметра ЗаменяемыеСимволы.
// 
//  Возвращаемое значение:
//   Строка - строка после замены символов.
//
//  Примечание: функция предназначена для простых случаев, например, для замены латиницы на похожие кириллические символы.
//              Функция не анализирует повторную замену символов, поэтому такой вызов:
//               ЗаменитьОдниСимволыДругими("кр", "карета", "гз") вернет слово "газета", а
//               ЗаменитьОдниСимволыДругими("кр", "карета", "рк") не вернет слово "ракета".
//
Функция ЗаменитьОдниСимволыДругими(ЗаменяемыеСимволы, Строка, СимволыЗамены) Экспорт
	
	Результат = Строка;
	
	Для НомерСимвола = 1 По СтрДлина(ЗаменяемыеСимволы) Цикл
		Результат = СтрЗаменить(Результат, Сред(ЗаменяемыеСимволы, НомерСимвола, 1), Сред(СимволыЗамены, НомерСимвола, 1));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Выполняет преобразование арабского числа в римское.
//
// Параметры:
//	АрабскоеЧисло		  - число, целое, от 0 до 999;
//	ИспользоватьКириллицу - булево, использовать в качестве арабских цифр кириллицу или латиницу.
//
// Возвращаемое значение:
//	Строка - число в римской нотации.
//
// Пример:
//	ПреобразоватьЧислоВРимскуюНотацию(17) = "ХVII".
//
Функция ПреобразоватьЧислоВРимскуюНотацию(АрабскоеЧисло, ИспользоватьКириллицу = Истина) Экспорт
	
	РимскоеЧисло	= "";
	АрабскоеЧисло	= ДополнитьСтроку(АрабскоеЧисло, 3);
	
	Если ИспользоватьКириллицу Тогда
		c1 = "1"; c5 = "У"; c10 = "Х"; c50 = "Л"; c100 ="С"; c500 = "Д"; c1000 = "М";
		
	Иначе
		c1 = "I"; c5 = "V"; c10 = "X"; c50 = "L"; c100 ="C"; c500 = "D"; c1000 = "M";
		
	КонецЕсли;
	
	Единицы	= Число(Сред(АрабскоеЧисло, 3, 1));
	Десятки	= Число(Сред(АрабскоеЧисло, 2, 1));
	Сотни	= Число(Сред(АрабскоеЧисло, 1, 1));
	
	РимскоеЧисло = РимскоеЧисло + ПреобразоватьЦифруВРимскуюНотацию(Сотни,   c100, c500, c1000);
	РимскоеЧисло = РимскоеЧисло + ПреобразоватьЦифруВРимскуюНотацию(Десятки, c10,  c50,  c100);
	РимскоеЧисло = РимскоеЧисло + ПреобразоватьЦифруВРимскуюНотацию(Единицы, c1,   c5,   c10);
	
	Возврат РимскоеЧисло;
	
КонецФункции 

// Выполняет преобразование римского числа в арабское
//
// Параметры:
//	РимскоеЧисло		  - Строка - число, записанное римскими цифрами;
//	ИспользоватьКириллицу - Булево - использовать в качестве арабских цифр кириллицу или латиницу.
//
// Возвращаемое значение:
//	Число.
//
// Пример:
//	ПреобразоватьЧислоВАрабскуюНотацию("ХVII") = 17.
//
Функция ПреобразоватьЧислоВАрабскуюНотацию(РимскоеЧисло, ИспользоватьКириллицу = Истина) Экспорт
	
	АрабскоеЧисло=0;
	
	Если ИспользоватьКириллицу Тогда
		c1 = "1"; c5 = "У"; c10 = "Х"; c50 = "Л"; c100 ="С"; c500 = "Д"; c1000 = "М";
		
	Иначе
		c1 = "I"; c5 = "V"; c10 = "X"; c50 = "L"; c100 ="C"; c500 = "D"; c1000 = "M";
		
	КонецЕсли;
	
	РимскоеЧисло = СокрЛП(РимскоеЧисло);
	ЧислоСимволов = СтрДлина(РимскоеЧисло);
	
	Для Сч=1 По ЧислоСимволов Цикл
		Если Сред(РимскоеЧисло,Сч,1) = c1000 Тогда
			АрабскоеЧисло = АрабскоеЧисло+1000;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c500 Тогда
			АрабскоеЧисло = АрабскоеЧисло+500;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c100 Тогда
			Если (Сч < ЧислоСимволов) И ((Сред(РимскоеЧисло,Сч+1,1) = c500) ИЛИ (Сред(РимскоеЧисло,Сч+1,1) = c1000)) Тогда
				АрабскоеЧисло = АрабскоеЧисло-100;
			Иначе
				АрабскоеЧисло = АрабскоеЧисло+100;
			КонецЕсли;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c50 Тогда
			АрабскоеЧисло = АрабскоеЧисло+50;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c10 Тогда
			Если (Сч < ЧислоСимволов) И ((Сред(РимскоеЧисло,Сч+1,1) = c50) ИЛИ (Сред(РимскоеЧисло,Сч+1,1) = c100)) Тогда
				АрабскоеЧисло = АрабскоеЧисло-10;
			Иначе
				АрабскоеЧисло = АрабскоеЧисло+10;
			КонецЕсли;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c5 Тогда
			АрабскоеЧисло = АрабскоеЧисло+5;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c1 Тогда
			Если (Сч < ЧислоСимволов) И ((Сред(РимскоеЧисло,Сч+1,1) = c5) ИЛИ (Сред(РимскоеЧисло,Сч+1,1) = c10)) Тогда
				АрабскоеЧисло = АрабскоеЧисло-1;
			Иначе
				АрабскоеЧисло = АрабскоеЧисло+1;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат АрабскоеЧисло;
	
КонецФункции 

// Возвращает текстовое представление числа с единицей измерения в правильном склонении и числе.
//
// Параметры:
//  Число                       - Число  - любое целое число.
//	ПараметрыПредметаИсчисления - Строка - варианты написания единицы измерения в родительном падеже для одной,
//										   для двух и для пяти единиц, разделитель - запятая.
//
// Возвращаемое значение:
//  Строка - текстовое представление количества единиц, число записывается цифрами.
//
// Примеры:
//  ЧислоЦифрамиПредметИсчисленияПрописью(23,  "минуту,минуты,минут") = "23 минуты";
// 	ЧислоЦифрамиПредметИсчисленияПрописью(15,  "минуту,минуты,минут") = "15 минут".
Функция ЧислоЦифрамиПредметИсчисленияПрописью(Знач Число, Знач ПараметрыПредметаИсчисления) Экспорт

	Результат = Формат(Число,"ЧН=0");
	
	МассивПредставлений = Новый Массив;
	
	Позиция = Найти(ПараметрыПредметаИсчисления, ",");
	Пока Позиция > 0 Цикл
		Значение = СокрЛП(Лев(ПараметрыПредметаИсчисления, Позиция-1));
		ПараметрыПредметаИсчисления = Сред(ПараметрыПредметаИсчисления, Позиция + 1);
		МассивПредставлений.Добавить(Значение);
		Позиция = Найти(ПараметрыПредметаИсчисления, ",");
	КонецЦикла;
	
	Если СтрДлина(ПараметрыПредметаИсчисления) > 0 Тогда
		Значение = СокрЛП(ПараметрыПредметаИсчисления);
		МассивПредставлений.Добавить(Значение);
	КонецЕсли;	
	
	Если Число >= 100 Тогда
		Число = Число - Цел(Число / 100)*100;
	КонецЕсли;
	
	Если Число > 20 Тогда
		Число = Число - Цел(Число/10)*10;
	КонецЕсли;
	
	Если Число = 1 Тогда
		Результат = Результат + " " + МассивПредставлений[0];
	ИначеЕсли Число > 1 И Число < 5 Тогда
		Результат = Результат + " " + МассивПредставлений[1];
	Иначе
		Результат = Результат + " " + МассивПредставлений[2];
	КонецЕсли;
	
	Возврат Результат;	
			
КонецФункции

// Очищает текст в формате HTML от тегов и возвращает неформатированный текст. 
//
// Параметры:
//  ИсходныйТекст - Строка - текст в формате HTML.
//
// Возвращаемое значение:
//  Строка - текст, очищенный от тегов, скриптов и заголовков.
//
Функция ИзвлечьТекстИзHTML(Знач ИсходныйТекст) Экспорт
	Результат = "";
	
	Текст = НРег(ИсходныйТекст);
	
	// отрезаем все что не body
	Позиция = Найти(Текст, "<body");
	Если Позиция > 0 Тогда
		Текст = Сред(Текст, Позиция + 5);
		ИсходныйТекст = Сред(ИсходныйТекст, Позиция + 5);
		Позиция = Найти(Текст, ">");
		Если Позиция > 0 Тогда
			Текст = Сред(Текст, Позиция + 1);
			ИсходныйТекст = Сред(ИсходныйТекст, Позиция + 1);
		КонецЕсли;
	КонецЕсли;
	
	Позиция = Найти(Текст, "</body>");
	Если Позиция > 0 Тогда
		Текст = Лев(Текст, Позиция - 1);
		ИсходныйТекст = Лев(ИсходныйТекст, Позиция - 1);
	КонецЕсли;
	
	// вырезаем скрипты
	Позиция = Найти(Текст, "<script");
	Пока Позиция > 0 Цикл
		ПозицияЗакрывающегоТега = Найти(Текст, "</script>");
		Если ПозицияЗакрывающегоТега = 0 Тогда
			// не найден закрывающий тег - вырезаем оставшийся текст.
			ПозицияЗакрывающегоТега = СтрДлина(Текст);
		КонецЕсли;
		Текст = Лев(Текст, Позиция - 1) + Сред(Текст, ПозицияЗакрывающегоТега + 9);
		ИсходныйТекст = Лев(ИсходныйТекст, Позиция - 1) + Сред(ИсходныйТекст, ПозицияЗакрывающегоТега + 9);
		Позиция = Найти(Текст, "<script");
	КонецЦикла;
	
	// вырезаем стили
	Позиция = Найти(Текст, "<style");
	Пока Позиция > 0 Цикл
		ПозицияЗакрывающегоТега = Найти(Текст, "</style>");
		Если ПозицияЗакрывающегоТега = 0 Тогда
			// не найден закрывающий тег - вырезаем оставшийся текст.
			ПозицияЗакрывающегоТега = СтрДлина(Текст);
		КонецЕсли;
		Текст = Лев(Текст, Позиция - 1) + Сред(Текст, ПозицияЗакрывающегоТега + 8);
		ИсходныйТекст = Лев(ИсходныйТекст, Позиция - 1) + Сред(ИсходныйТекст, ПозицияЗакрывающегоТега + 8);
		Позиция = Найти(Текст, "<style");
	КонецЦикла;
	
	// вырезаем все теги	
	Позиция = Найти(Текст, "<");
	Пока Позиция > 0 Цикл
		Результат = Результат + Лев(ИсходныйТекст, Позиция-1);
		Текст = Сред(Текст, Позиция + 1);
		ИсходныйТекст = Сред(ИсходныйТекст, Позиция + 1);
		Позиция = Найти(Текст, ">");
		Если Позиция > 0 Тогда
			Текст = Сред(Текст, Позиция + 1);
			ИсходныйТекст = Сред(ИсходныйТекст, Позиция + 1);
		КонецЕсли;
		Позиция = Найти(Текст, "<");
	КонецЦикла;
	Результат = Результат + ИсходныйТекст;
	
	Возврат СокрЛП(Результат);
КонецФункции

// Преобразует исходную строку в транслит.
Функция СтрокаЛатиницей(Знач Строка) Экспорт
	Результат = "";
	
	Соответствие = СоответствиеКириллицыИЛатиницы();
	
	ПредыдущийСимвол = "";
	Для Позиция = 1 По СтрДлина(Строка) Цикл
		Символ = Сред(Строка, Позиция, 1);
		СимволЛатиницей = Соответствие[НРег(Символ)]; // поиск соответствия без учета регистра
		Если СимволЛатиницей = Неопределено Тогда
			// другие символы остаются "как есть"
			СимволЛатиницей = Символ;
		Иначе
			Если Символ = ВРег(Символ) Тогда
				СимволЛатиницей = ТРег(СимволЛатиницей); // восстанавливаем регистр
			КонецЕсли;
		КонецЕсли;
		Результат = Результат + СимволЛатиницей;
		ПредыдущийСимвол = СимволЛатиницей;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет преобразование цифры в римскую нотацию. 
//
// Параметры
//	Цифра - Число - цифра от 0 до 9.
//  РимскаяЕдиница, РимскаяПятерка, РимскаяДесятка - Строка - символы, соответствующие римским цифрам.
//
// Возвращаемое значение
//	Строка - цифра в римской нотации.
//
// Пример: 
//	ПреобразоватьЦифруВРимскуюНотацию(7,"I","V","X") = "VII".
//
Функция ПреобразоватьЦифруВРимскуюНотацию(Цифра, РимскаяЕдиница, РимскаяПятерка, РимскаяДесятка)
	
	РимскаяЦифра="";
	Если Цифра = 1 Тогда
		РимскаяЦифра = РимскаяЕдиница
	ИначеЕсли Цифра = 2 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 3 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 4 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяПятерка;
	ИначеЕсли Цифра = 5 Тогда
		РимскаяЦифра = РимскаяПятерка;
	ИначеЕсли Цифра = 6 Тогда
		РимскаяЦифра = РимскаяПятерка + РимскаяЕдиница;
	ИначеЕсли Цифра = 7 Тогда
		РимскаяЦифра = РимскаяПятерка + РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 8 Тогда
		РимскаяЦифра = РимскаяПятерка + РимскаяЕдиница + РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 9 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяДесятка;
	КонецЕсли;
	Возврат РимскаяЦифра;
	
КонецФункции

// Вставляет параметры в строку, учитывая, что в параметрах могут использоваться подстановочные слова %1, %2 и т.д.
Функция ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	Результат = "";
	Позиция = Найти(СтрокаПодстановки, "%");
	Пока Позиция > 0 Цикл 
		Результат = Результат + Лев(СтрокаПодстановки, Позиция - 1);
		СимволПослеПроцента = Сред(СтрокаПодстановки, Позиция + 1, 1);
		ПодставляемыйПараметр = "";
		Если СимволПослеПроцента = "1" Тогда
			ПодставляемыйПараметр =  Параметр1;
		ИначеЕсли СимволПослеПроцента = "2" Тогда
			ПодставляемыйПараметр =  Параметр2;
		ИначеЕсли СимволПослеПроцента = "3" Тогда
			ПодставляемыйПараметр =  Параметр3;
		ИначеЕсли СимволПослеПроцента = "4" Тогда
			ПодставляемыйПараметр =  Параметр4;
		ИначеЕсли СимволПослеПроцента = "5" Тогда
			ПодставляемыйПараметр =  Параметр5;
		ИначеЕсли СимволПослеПроцента = "6" Тогда
			ПодставляемыйПараметр =  Параметр6;
		ИначеЕсли СимволПослеПроцента = "7" Тогда
			ПодставляемыйПараметр =  Параметр7
		ИначеЕсли СимволПослеПроцента = "8" Тогда
			ПодставляемыйПараметр =  Параметр8;
		ИначеЕсли СимволПослеПроцента = "9" Тогда
			ПодставляемыйПараметр =  Параметр9;
		КонецЕсли;
		Если ПодставляемыйПараметр = "" Тогда
			Результат = Результат + "%";
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 1);
		Иначе
			Результат = Результат + ПодставляемыйПараметр;
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 2);
		КонецЕсли;
		Позиция = Найти(СтрокаПодстановки, "%");
	КонецЦикла;
	Результат = Результат + СтрокаПодстановки;
	
	Возврат Результат;
КонецФункции

Функция СоответствиеКириллицыИЛатиницы()
	// транслитерация, используемая в загранпаспортах 1997-2010 гг.
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("а","a");
	Соответствие.Вставить("б","b");
	Соответствие.Вставить("в","v");
	Соответствие.Вставить("г","g");
	Соответствие.Вставить("д","d");
	Соответствие.Вставить("е","e");
	Соответствие.Вставить("ё","e");
	Соответствие.Вставить("ж","zh");
	Соответствие.Вставить("з","z");
	Соответствие.Вставить("и","i");
	Соответствие.Вставить("й","y");
	Соответствие.Вставить("к","k");
	Соответствие.Вставить("л","l");
	Соответствие.Вставить("м","m");
	Соответствие.Вставить("н","n");
	Соответствие.Вставить("о","o");
	Соответствие.Вставить("п","p");
	Соответствие.Вставить("р","r");
	Соответствие.Вставить("с","s");
	Соответствие.Вставить("т","t");
	Соответствие.Вставить("у","u");
	Соответствие.Вставить("ф","f");
	Соответствие.Вставить("х","kh");
	Соответствие.Вставить("ц","ts");
	Соответствие.Вставить("ч","ch");
	Соответствие.Вставить("ш","sh");
	Соответствие.Вставить("щ","shch");
	Соответствие.Вставить("ъ","""");
	Соответствие.Вставить("ы","y");
	Соответствие.Вставить("ь",""); // пропускается
	Соответствие.Вставить("э","e");
	Соответствие.Вставить("ю","yu");
	Соответствие.Вставить("я","ya");
	
	Возврат Соответствие;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// УСТАРЕВШИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Устарела. Следует использовать СтрокаИзМассиваПодстрок.
//
// Объединяет строки из массива в строку с разделителями.
//
// Параметры:
//  Массив      - Массив - массив строк которые необходимо объединить в одну строку;
//  Разделитель - Строка - любой набор символов, который будет использован в качестве разделителя.
//
// Возвращаемое значение:
//  Строка - строка с разделителями.
// 
Функция ПолучитьСтрокуИзМассиваПодстрок(Массив, Разделитель = ",") Экспорт
	
	// возвращаемое значение функции
	Результат = "";
	
	Для Каждого Элемент Из Массив Цикл
		
		Подстрока = ?(ТипЗнч(Элемент) = Тип("Строка"), Элемент, Строка(Элемент));
		
		РазделительПодстрок = ?(ПустаяСтрока(Результат), "", Разделитель);
		
		Результат = Результат + РазделительПодстрок + Подстрока;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
