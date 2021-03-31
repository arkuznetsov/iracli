// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/iracli/
// ----------------------------------------------------------

// Функция - читает указанный макет JSON и возвращает содержимое в виде структуры/массива
//
// Параметры:
//	ПутьКМакету    - Строка   - путь к макету json
//
// Возвращаемое значение:
//	Структура, Массив       - прочитанные данные из макета 
//
Функция ПрочитатьДанныеИзМакетаJSON(Знач ПутьКМакету, Знач ВСоответствие = Ложь) Экспорт

	Чтение = Новый ЧтениеJSON();

	ПутьКМакету = ПолучитьМакет(ПутьКМакету);
	
	Чтение.ОткрытьФайл(ПутьКМакету, КодировкаТекста.UTF8);
	
	Возврат ПрочитатьJSON(Чтение, ВСоответствие);

КонецФункции // ПрочитатьДанныеИзМакетаJSON()

// Функция - получает значение настройки из соответствия или структуры по ключу без учета регистра ключа
//   
// Параметры:
//   Настройка      - Строка                    - ключ (имя) настройки
//   ВсеНастройки   - Структура, Соответствие   - контейнер настроек
//   ПоУмолчанию    - Произвольный              - значение настройки по умолчанию
//                                                возвращается если контейнер не содержит указанную настройку
//   
// Возвращаемое значение:
//    Произвольный   - значение настройки или значение по умолчанию
//
Функция ПолучитьЗначениеНастройки(Настройка, ВсеНастройки, ПоУмолчанию = Неопределено) Экспорт
	
	ЭтоНастройки = (ТипЗнч(ВсеНастройки) = Тип("Соответствие")
	            ИЛИ ТипЗнч(ВсеНастройки) = Тип("ФиксированноеСоответствие")
	            ИЛИ ТипЗнч(ВсеНастройки) = Тип("Структура")
	            ИЛИ ТипЗнч(ВсеНастройки) = Тип("ФиксированнаяСтруктура"));

	Если НЕ ЭтоНастройки Тогда
		Возврат ПоУмолчанию;
	КонецЕсли;

	Для Каждого ТекНастройка Из ВсеНастройки Цикл
		Если НРег(ТекНастройка.Ключ) = НРег(Настройка) Тогда
			Возврат ТекНастройка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПоУмолчанию;
	
КонецФункции // ПолучитьЗначениеНастройки()

// Функция проверяет, что переданное значение является числом или строковым представлением числа
//   
// Параметры:
//   Параметр      - Строка, Число     - значение для проверки
//
// Возвращаемое значение:
//    Булево       - Истина - значение является числом или строковым представлением числа
//
Функция ЭтоGUID(Параметр) Экспорт

	РВ = Новый РегулярноеВыражение("(?i)[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}");
	
	Возврат РВ.Совпадает(Параметр);

КонецФункции // ЭтоGUID()

// Функция - возвращает Истина если значение является пустым GUID
//
// Параметры:
//    Значение      - Строка     - проверяемое значение
//
// Возвращаемое значение:
//    Булево     - Истина - значение является пустым GUID
//
Функция ЭтоПустойGUID(Значение) Экспорт

	Возврат (Значение = "00000000-0000-0000-0000-000000000000") ИЛИ НЕ ЗначениеЗаполнено(Значение);

КонецФункции // ЭтоПустойGUID()

// Процедура - убирает в строке начальные и конечные кавычки
//
// Параметры:
//	Значение    - Строка     - строка для обработки
//
// Возвращаемое значение:
//    Строка     - строка без кавычек
//
Процедура УбратьКавычки(Значение) Экспорт

	Если Лев(Значение, 1) = """"  И Прав(Значение, 1) = """" Тогда
		Значение = Сред(Значение, 2, СтрДлина(Значение) - 2);
	КонецЕсли;

КонецПроцедуры // УбратьКавычки()

// Процедура - выполняет преобразование переданных данных в JSON
//
// Параметры:
//    Данные       - Произвольный     - данные для преобразования
//
// Возвращаемое значение:
//    Строка     - результат преобразованияданные для преобразования
//
Функция ДанныеВJSON(Знач Данные) Экспорт
	
	Запись = Новый ЗаписьJSON();
	
	Запись.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix, Символы.Таб));

	Попытка
		ЗаписатьJSON(Запись, Данные);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Возврат Запись.Закрыть();
	
КонецФункции // ДанныеВJSON()

// Функция возвращает структуру операторов сравнения
//
// Возвращаемое значение:
//    ФиксированнаяСтруктура - операторы сравнения
//
Функция ОператорыСравнения() Экспорт

	ОператорыСравнения = Новый Структура();

	ОператорыСравнения.Вставить("Равно"         , "EQ");
	ОператорыСравнения.Вставить("НеРавно"       , "NEQ");
	ОператорыСравнения.Вставить("Больше"        , "GT");
	ОператорыСравнения.Вставить("БольшеИлиРавно", "GTE");
	ОператорыСравнения.Вставить("Меньше"        , "LT");
	ОператорыСравнения.Вставить("МеньшеИлиРавно", "LTE");

	Возврат Новый ФиксированнаяСтруктура(ОператорыСравнения);

КонецФункции // ОператорыСравнения()

// Функция возвращает соответствия псевдонимов операторам сравнения
//
// Возвращаемое значение:
//    ФиксированноеСоответствие - псевдонимы операторов сравнения
//
Функция ПсевдонимыОператоровСравнения() Экспорт

	ОператорыСравнения = ОператорыСравнения();

	ПсевдонимыОператоров = Новый Соответствие();

	Для Каждого ТекЭлемент Из ОператорыСравнения Цикл
		ПсевдонимыОператоров.Вставить(ТекЭлемент.Значение, ТекЭлемент.Значение);
	КонецЦикла;

	ПсевдонимыОператоров.Вставить("EQUAL"             , ОператорыСравнения.Равно);
	ПсевдонимыОператоров.Вставить("NOTEQUAL"          , ОператорыСравнения.НеРавно);
	ПсевдонимыОператоров.Вставить("GREATERTHEN"       , ОператорыСравнения.Больше);
	ПсевдонимыОператоров.Вставить("GREATERTHENOREQUAL", ОператорыСравнения.БольшеИлиРавно);
	ПсевдонимыОператоров.Вставить("LESSTHEN"          , ОператорыСравнения.Меньше);
	ПсевдонимыОператоров.Вставить("LESSTHENOREQUAL"   , ОператорыСравнения.МеньшеИлиРавно);

	Возврат Новый ФиксированноеСоответствие(ПсевдонимыОператоров);

КонецФункции // ПсевдонимыОператоровСравнения()

// Функция получает список полей из строки или массива
//   
// Параметры:
//   Поля                - Массив, Строка  - список полей
//   ВсеПоля             - Строка          - строковое представления добавления всех полей
//
// Возвращаемое значение:
//    Массив из Строка   - список полей, если параметр не Массив или Строка,
//                         то результат содержит единственный элемент со значением параметра "ВсеПоля"
//
Функция СписокПолей(Знач Поля, Знач ВсеПоля = "_ALL") Экспорт

	Если ТипЗнч(Поля) = Тип("Строка") Тогда
		СписокПолей = СтрРазделить(Поля, ",", Ложь);
		Для й = 0 По СписокПолей.ВГраница() Цикл
			СписокПолей[й] = ВРег(СокрЛП(СписокПолей[й]));
		КонецЦикла;
	ИначеЕсли ТипЗнч(Поля) = Тип("Массив") Тогда
		СписокПолей = Поля;
	Иначе
		СписокПолей = Новый Массив();
		СписокПолей.Добавить(ВРег(ВсеПоля));
	КонецЕсли;

	Возврат СписокПолей;

КонецФункции // СписокПолей()

// Функция выполняет сравнение значений
//   
// Параметры:
//   ЛевоеЗначение      - Произвольный  - левое значение сравнения
//   Оператор           - Строка        - оператор сравнения
//   ПравоеЗначение     - Произвольный  - правое значение сравнения
//   РегистроНезависимо - Булево        - Истина - при сравнении на (не)равенство
//                                        не будет учитываться регистр сравниваемых значений
//
// Возвращаемое значение:
//    Булево            - Истина - сравнение истино
//
Функция СравнитьЗначения(Знач ЛевоеЗначение,
	                     Знач Оператор,
	                     Знач ПравоеЗначение,
	                     Знач РегистроНезависимо = Истина) Экспорт

	ОператорыСравнения = ОператорыСравнения();

	Результат = Ложь;

	Если РегистроНезависимо И (Оператор = ОператорыСравнения.Равно ИЛИ Оператор = ОператорыСравнения.НеРавно) Тогда
		ЛевоеЗначение  = ВРег(ЛевоеЗначение);
		ПравоеЗначение = ВРег(ПравоеЗначение);
	КонецЕсли;

	Если НЕ ТипЗнч(ЛевоеЗначение) = ТипЗнч(ПравоеЗначение) Тогда
		Если ТипЗнч(ЛевоеЗначение) = Тип("Число") Тогда
			ПравоеЗначение = Число(ПравоеЗначение);
		ИначеЕсли ТипЗнч(ЛевоеЗначение) = Тип("Дата") Тогда
			ПравоеЗначение = ПрочитатьДатуJSON(ПравоеЗначение, ФорматДатыJSON.ISO);
		ИначеЕсли ТипЗнч(ЛевоеЗначение) = Тип("Булево") Тогда
			ПравоеЗначение = ?(ВРег(ПравоеЗначение) = "TRUE" ИЛИ ВРег(ПравоеЗначение) = "ИСТИНА", Истина, Ложь);
		Иначе
			ЛевоеЗначение  = Строка(ЛевоеЗначение);
			ПравоеЗначение = Строка(ПравоеЗначение);
		КонецЕсли;
	КонецЕсли;
			
	
	Если Оператор = ОператорыСравнения.Равно И ЛевоеЗначение = ПравоеЗначение Тогда
		Результат = Истина;
	ИначеЕсли Оператор = ОператорыСравнения.НеРавно И НЕ ЛевоеЗначение = ПравоеЗначение Тогда
		Результат = Истина;
	ИначеЕсли Оператор = ОператорыСравнения.Больше И ЛевоеЗначение > ПравоеЗначение Тогда
		Результат = Истина;
	ИначеЕсли Оператор = ОператорыСравнения.БольшеИлиРавно И ЛевоеЗначение >= ПравоеЗначение Тогда
		Результат = Истина;
	ИначеЕсли Оператор = ОператорыСравнения.Меньше И ЛевоеЗначение < ПравоеЗначение Тогда
		Результат = Истина;
	ИначеЕсли Оператор = ОператорыСравнения.МеньшеИлиРавно И ЛевоеЗначение <= ПравоеЗначение Тогда
		Результат = Истина;
	КонецЕсли;

	Возврат Результат;

КонецФункции // СравнитьЗначения()

// Функция проверяет соответствие значения указанному набору сравнений (фильтру)
// результаты сравнений объединяются по "И"
//   
// Параметры:
//   Значение           - Произвольный         - проверяемое значение
//   Фильтр             - Массив из Структура  - набор сравнений (фильтр)
//       * Оператор         - Строка               - оператор сравнения
//       * Значение         - Произвольный         - значение для сравнения
//   РегистроНезависимо - Булево               - Истина - при сравнении на (не)равенство
//   
// Возвращаемое значение:
//    Булево            - Истина - значение соответствует фильтру
//
Функция ЗначениеСоответствуетФильтру(Знач Значение, Знач Фильтр, Знач РегистроНезависимо = Истина) Экспорт

	Результат = Истина;

	Если НЕ (ЗначениеЗаполнено(Фильтр) И ТипЗнч(Фильтр) = Тип("Массив")) Тогда
		Возврат Результат;
	КонецЕсли;

	Для Каждого ТекСравнение Из Фильтр Цикл
		Результат = СравнитьЗначения(Значение, ТекСравнение.Оператор, ТекСравнение.Значение, РегистроНезависимо);
		Если НЕ Результат Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции // ЗначениеСоответствуетЭлементуФильтра()

// Функция проверяет соответствие значений полей объекта указанному набору сравнений (фильтру)
// результаты сравнений объединяются по "И"
//   
// Параметры:
//   Объект             - Соответствие         - проверяемый объект
//   Фильтр             - Массив из Структура  - набор сравнений (фильтр)
//       * Оператор         - Строка               - оператор сравнения
//       * Значение         - Произвольный         - значение для сравнения
//   РегистроНезависимо - Булево               - Истина - при сравнении на (не)равенство
//   
// Возвращаемое значение:
//    Булево            - Истина - значения полей объекта соответствует фильтру
//
Функция ОбъектСоответствуетФильтру(Объект, Фильтр, РегистроНезависимо = Истина) Экспорт

	Результат = Истина;

	Если НЕ (ЗначениеЗаполнено(Фильтр) И ТипЗнч(Фильтр) = Тип("Соответствие")) Тогда
		Возврат Результат;
	КонецЕсли;

	Для Каждого ТекЭлементФильтра Из Фильтр Цикл
		Если Объект[ТекЭлементФильтра.Ключ] = Неопределено Тогда
			Результат = Ложь;
			Прервать;
		КонецЕсли;
		Результат = ЗначениеСоответствуетФильтру(Объект[ТекЭлементФильтра.Ключ], ТекЭлементФильтра.Значение);
		Если НЕ Результат Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции // ОбъектСоответствуетФильтру()

// Функция выделяет фильтр из параметров запроса
//   
// Параметры:
//   ФильтрСтрокой       - Строка       - строка фильтра данных
//   
// Возвращаемое значение:
//    Соответствие                                   - фильтр
//        <имя поля>      - Массив из Структура      - фильтр для поля <имя поля>
//           * Оператор         - Строка                 - оператор сравнения
//           * Значение         - Произвольный           - значение для сравнения
//
Функция ФильтрИзПараметровЗапроса(ФильтрСтрокой) Экспорт

	Если НЕ ЗначениеЗаполнено(ФильтрСтрокой) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Фильтр = Новый Соответствие();
	ОператорыСравнения = ОбщегоНазначения.ОператорыСравнения();
	ПсевдонимыОператоровСравнения = ОбщегоНазначения.ПсевдонимыОператоровСравнения();

	ВыраженияФильтра = СтрРазделить(ФильтрСтрокой, ",", Ложь);

	Для й = 0 По ВыраженияФильтра.ВГраница() Цикл

		ТекВыражение = СтрРазделить(СокрЛП(ВыраженияФильтра[й]), "=");

		ИмяПоля = ТекВыражение[0];
		Оператор = ОбщегоНазначения.ОператорыСравнения().Равно;
		ОкончаниеОператора = Найти(ИмяПоля, "_");
		Если ОкончаниеОператора > 0 Тогда
			ПсевдонимОператора = ВРег(Сред(ИмяПоля, 1, ОкончаниеОператора - 1));
			Если НЕ ПсевдонимыОператоровСравнения.Получить(ПсевдонимОператора) = Неопределено Тогда
				Оператор = ПсевдонимыОператоровСравнения[ПсевдонимОператора];
				ИмяПоля = Сред(ИмяПоля, ОкончаниеОператора + 1);
			КонецЕсли;
		КонецЕсли;

		Если Фильтр[ИмяПоля] = Неопределено Тогда
			Фильтр.Вставить(ИмяПоля, Новый Массив());
		КонецЕсли;

		Фильтр[ИмяПоля].Добавить(Новый Структура("Оператор, Значение", Оператор, ТекВыражение[1]));
	КонецЦикла;

	Возврат Фильтр;

КонецФункции // ФильтрИзПараметровЗапроса()

Функция ВыборкаПервыхИзПараметровЗапроса(ПервыеСтрокой) Экспорт

	Если НЕ ЗначениеЗаполнено(ПервыеСтрокой) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Первые = Неопределено;

	ОкончаниеПоля = СтрНайти(ПервыеСтрокой, "=");

	Если ОкончаниеПоля = 0 Тогда
		Первые = Новый Структура("ИмяПоля, Количество");
		Первые.ИмяПоля = "_value";
		Первые.Количество = Число(ПервыеСтрокой);
	Иначе
		Первые = Новый Структура("ИмяПоля, Количество");
		Первые.ИмяПоля = Лев(ПервыеСтрокой, ОкончаниеПоля - 1);
		Первые.Количество = Число(Сред(ПервыеСтрокой, ОкончаниеПоля + 1));
	КонецЕсли;

	Возврат Первые;

КонецФункции // ВыборкаПервыхИзПараметровЗапроса()

Функция ПервыеПоЗначениюПоля(Элементы, ИмяПоля, Количество) Экспорт

	ТабСортировки = Новый ТаблицаЗначений();
	ТабСортировки.Колонки.Добавить("ЗначениеСортировки");
	ТабСортировки.Колонки.Добавить("Элемент");

	Сортировка = "УБЫВ";

	Для Каждого ТекЭлемент Из Элементы Цикл
		НоваяСтрока = ТабСортировки.Добавить();
		НоваяСтрока.ЗначениеСортировки = ТекЭлемент[ИмяПоля];
		НоваяСтрока.Элемент            = ТекЭлемент;
		
		Если Сортировка = "УБЫВ" И ТипЗнч(НоваяСтрока.ЗначениеСортировки) = Тип("Строка") Тогда
			Сортировка = "ВОЗР";
		КонецЕсли;
	КонецЦикла;

	ТабСортировки.Сортировать(СтрШаблон("ЗначениеСортировки %1", Сортировка));

	Количество = Мин(Количество, ТабСортировки.Количество());

	Результат = Новый Массив();

	Для й = 0 По Количество - 1 Цикл
		Результат.Добавить(ТабСортировки[й].Элемент);
	КонецЦикла;

	Возврат Результат;

КонецФункции // ПервыеПоЗначениюПоля()
