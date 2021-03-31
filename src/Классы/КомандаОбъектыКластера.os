// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/yard/
// ----------------------------------------------------------

#Использовать irac

Перем ТипОбъектовКластера;   // Перечисление.РежимыАдминистрирования    - тип обрабатываемых объектов кластера

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Если ТипОбъектовКластера = Перечисления.РежимыАдминистрирования.Кластеры Тогда
		ИмяОбъектов = "кластеров";
		ИмяОбъекта = "кластера";
	ИначеЕсли ТипОбъектовКластера = Перечисления.РежимыАдминистрирования.Серверы Тогда
		ИмяОбъектов = "серверов";
		ИмяОбъекта = "сервера";
	ИначеЕсли ТипОбъектовКластера = Перечисления.РежимыАдминистрирования.РабочиеПроцессы Тогда
		ИмяОбъектов = "рабочих процессов";
		ИмяОбъекта = "рабочего процесса";
	ИначеЕсли ТипОбъектовКластера = Перечисления.РежимыАдминистрирования.ИнформационныеБазы Тогда
		ИмяОбъектов = "информационных баз";
		ИмяОбъекта = "информационной базы";
	ИначеЕсли ТипОбъектовКластера = Перечисления.РежимыАдминистрирования.Сеансы Тогда
		ИмяОбъектов = "сеансов";
		ИмяОбъекта = "сеанса";
	ИначеЕсли ТипОбъектовКластера = Перечисления.РежимыАдминистрирования.Соединения Тогда
		ИмяОбъектов = "соединений";
		ИмяОбъекта = "соединения";
	КонецЕсли;

	Команда.ДобавитьКоманду("list l",
	                        СтрШаблон("список %1 1С", ИмяОбъектов),
	                        Новый КомандаСписокОбъектовКластера(ТипОбъектовКластера));
	Команда.ДобавитьКоманду("get g",
	                        СтрШаблон("описание %1 1С", ИмяОбъекта),
	                        Новый КомандаОписаниеОбъектаКластера(ТипОбъектовКластера));
	Команда.ДобавитьКоманду("counter c",
	                        СтрШаблон("счетчики %1 1С", ИмяОбъектов),
	                        Новый КомандаСчетчикиОбъектаКластера(ТипОбъектовКластера));
	
КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

КонецПроцедуры // ВыполнитьКоманду()

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// Параметры:
//  ТипОбъектов	 - Перечисление.РежимыАдминистрирования    - тип обрабатываемых объектов кластера
// 
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта(Знач ТипОбъектов)

	ТипОбъектовКластера = ТипОбъектов;

	Лог = ПараметрыПриложения.Лог();

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on
