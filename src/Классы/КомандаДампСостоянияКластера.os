// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/iracli/
// ----------------------------------------------------------

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("c count", 1, "количество сохраняемых дампов")
	       .ТЧисло()
	       .ВОкружении("IRAC_DUMP_COUNT");
	
	Команда.Опция("t time", 60, "переодичность дампа в секундах")
	       .ТЧисло()
	       .ВОкружении("IRAC_DUMP_TIME");
	
	Команда.Опция("s summary", false, "для информационных баз и соединений получать только основные данные")
	       .ТБулево()
	       .ВОкружении("IRAC_DUMP_SUMMARY");
	
	Команда.Аргумент("PATH", ".", "путь к каталогу дампа объектов кластера 1С")
	       .ТСтрока()
	       .ВОкружении("IRAC_DUMP_PATH");

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ВыводОтладочнойИнформации = Команда.ЗначениеОпции("verbose");

	ПараметрыПриложения.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПутьККаталогу        = Команда.ЗначениеАргумента("PATH");
	Количество           = Команда.ЗначениеОпции("count");
	Периодичность        = Команда.ЗначениеОпции("time");
	ТолькоОсновныеДанные = Команда.ЗначениеОпции("summary");

	КоличествоДампов = 0;

	ОбрабатываемыеОбъекты = ОбрабатываемыеОбъектыКластера();

	Для й = 1 По Количество Цикл

		Если й > 1 Тогда
			Приостановить(Периодичность * 1000);
		КонецЕсли;

		Дамп = Новый Соответствие();
		Дамп.Вставить("startDate"    , ТекущаяУниверсальнаяДата());
		Дамп.Вставить("startTimemark", ТекущаяУниверсальнаяДатаВМиллисекундах());
	
		Для Каждого ТекОбъект Из ОбрабатываемыеОбъекты Цикл
			ПараметрыЗамера = ЗамерыВремени.НачатьЗамер(СтартовыйСценарий().Источник,
			                                            СтрСоединить(Новый Массив(АргументыКоманднойСтроки), " "),
			                                            ТекОбъект,
			                                            "list");

			Дамп.Вставить(ТекОбъект, Новый Структура());

			Дамп[ТекОбъект].Вставить("startDate"    , ТекущаяУниверсальнаяДата());
			Дамп[ТекОбъект].Вставить("startTimemark", ТекущаяУниверсальнаяДатаВМиллисекундах());

			Поля = "_all";
			Если ТолькоОсновныеДанные
			   И (ТекОбъект = Перечисления.РежимыАдминистрирования.ИнформационныеБазы
			   ИЛИ ТекОбъект = Перечисления.РежимыАдминистрирования.Соединения) Тогда
				Поля = "_summary";
			КонецЕсли;

			ОбъектыКластера = ПодключенияКАгентам.ОбъектыКластера(ТекОбъект, Истина, Поля, Неопределено);
			
			Дамп[ТекОбъект].Вставить("data", ОбъектыКластера);

			Дамп[ТекОбъект].Вставить("endDate"    , ТекущаяУниверсальнаяДата());
			Дамп[ТекОбъект].Вставить("endTimemark", ТекущаяУниверсальнаяДатаВМиллисекундах());
			Дамп[ТекОбъект].Вставить("duration"   , Дамп[ТекОбъект]["endTimemark"] - Дамп[ТекОбъект]["startTimemark"]);

			ЗамерыВремени.ЗафиксироватьОкончаниеЗамера(ПараметрыЗамера);
		КонецЦикла;

		Дамп.Вставить("endDate"    , ТекущаяУниверсальнаяДата());
		Дамп.Вставить("endTimemark", ТекущаяУниверсальнаяДатаВМиллисекундах());
		Дамп.Вставить("duration"   , Дамп["endTimemark"] - Дамп["startTimemark"]);

		ИмяФайла = СтрШаблон("1cluster_dump_%1.json", Формат(Дамп["startDate"], "ДФ=yyyyMMdd_hhmmss"));

		Запись = Новый ЗаписьJSON();
		Запись.ОткрытьФайл(ОбъединитьПути(ПутьККаталогу, ИмяФайла),
		                   "UTF-8",
		                   Ложь,
		                   Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix, Символы.Таб));
		
		ЗаписатьJSON(Запись, Дамп);
		
		Запись.Закрыть();

	КонецЦикла;

КонецПроцедуры // ВыполнитьКоманду()

Функция ОбрабатываемыеОбъектыКластера()

	Результат = Новый Массив();
	Результат.Добавить(Перечисления.РежимыАдминистрирования.Кластеры);
	Результат.Добавить(Перечисления.РежимыАдминистрирования.Серверы);
	Результат.Добавить(Перечисления.РежимыАдминистрирования.РабочиеПроцессы);
	Результат.Добавить(Перечисления.РежимыАдминистрирования.ИнформационныеБазы);
	Результат.Добавить(Перечисления.РежимыАдминистрирования.Сеансы);
	Результат.Добавить(Перечисления.РежимыАдминистрирования.Соединения);

	Возврат Новый ФиксированныйМассив(Результат);

КонецФункции // ОбрабатываемыеОбъектыКластера()

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// Параметры:
//  ТипОбъектов	 - Перечисление.РежимыАдминистрирования    - тип обрабатываемых объектов кластера
// 
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта()

	Лог = ПараметрыПриложения.Лог();

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on
