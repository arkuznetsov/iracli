# Comand line interface for RAC

[![GitHub release](https://img.shields.io/github/release/ArKuznetsov/iracli.svg?style=flat-square)](https://github.com/ArKuznetsov/iracli/releases)
[![GitHub license](https://img.shields.io/github/license/ArKuznetsov/iracli.svg?style=flat-square)](https://github.com/ArKuznetsov/iracli/blob/develop/LICENSE)
[![Build Status](https://img.shields.io/github/workflow/status/ArKuznetsov/iracli/%D0%9A%D0%BE%D0%BD%D1%82%D1%80%D0%BE%D0%BB%D1%8C%20%D0%BA%D0%B0%D1%87%D0%B5%D1%81%D1%82%D0%B2%D0%B0)](https://github.com/arkuznetsov/iracli/actions/)
[![Quality Gate](https://img.shields.io/sonar/quality_gate/iracli?server=https%3A%2F%2Fopen.checkbsl.org&sonarVersion=8.6)](https://open.checkbsl.org/dashboard/index/iracli)
[![Coverage](https://img.shields.io/sonar/coverage/iracli?server=https%3A%2F%2Fopen.checkbsl.org&sonarVersion=8.6)](https://open.checkbsl.org/dashboard/index/iracli)
[![Tech debt](https://img.shields.io/sonar/tech_debt/iracli?server=https%3A%2F%2Fopen.checkbsl.org&sonarVersion=8.6)](https://open.checkbsl.org/dashboard/index/iracli)

Приложение oscript для взаимодействия с сервисом администрирования 1С

## Требования

Требуются следующие библиотеки и инструменты:
- [logos](https://github.com/oscript-library/logos)
- [asserts](https://github.com/oscript-library/asserts)
- [cli](https://github.com/oscript-library/cli)
- [irac](https://github.com/oscript-library/v8runner)
- [1C RAC](https://releases.1c.ru/project/Platform83) - утилита RAC из состава платформы 1С:Предприятие 8.3

## Варианты запросов

  - **<имя объекта> list** - список объектов
  - **<имя объекта> <путь к объекту>** - содержимое объекта по указанному пути
  - **<имя объекта> <путь к объекту> <свойство>** - значение свойства <свойство> объекта по указанному пути
  - **counter list** - описания доступных счетчиков
  - **counter <имя объекта> list** - описания доступных счетчиков для <имя объекта>
  - **counter <имя объекта> <счетчик>** - значения счетчика <счетчик> для <имя объекта>

### Используемые имена объектов (`<имя объекта>`)

  - **cluster** - информация о кластерах
  - **server** - информация о рабочих серверах
  - **process** - информация о рабочих процессах
  - **infobase** - информация об информационных базах
  - **session** - информация о сеансах
  - **connection** - информация о соединениях

### Пути к объектам (`<путь к объекту>`)

  - **cluster** - cluster/<адрес сервера>/<порт сервера>
  - **server** - server/<адрес сервера>/<порт сервера>
  - **process** - process/<адрес сервера>/<порт процесса>
  - **infobase** - infobase/<имя информационной базы>
  - **session** - session/<имя информационной базы>/<номер сеанса>
  - **connection** - connection/<имя информационной базы>/<номер сеанса>

## Доступные поля запросов

### Доступные поля запроса списка (`<имя объекта> list`)

  - **field** - имя поля запрашиваемого объекта, которое попадет в результат (`field=all` - попадут все поля)
  - **filter_<операция сравнения>_<поле объекта>** - условие (фильтр) по значению поля
  - **top_<поле объекта>** - отбор указанного количества первых результатов с максимальным значением поля <поле объекта>

### Доступные поля запроса счетчиков (`counter <имя объекта>`)

  - **filter_<операция сравнения>_<поле объекта>** - условие (фильтр) по значению поля
  - **dim** - имя измерения счетчика по которым выполняется свертка значения счетчика (`dim=all` - попадут все измерения счетчика)
  - **top** - отбор указанного количества первых значений счетчика с максимальным значением
  - **aggregate** - агрегатная функция свертки значений счетчика
  - **format** - формат вывода результата

### Доступные операции сравнения фильтров

  - **eq** - равно (может не указываться), для строк выполняется без учета регистра
  - **neq** - не равно, для строк выполняется без учета регистра
  - **gt** - больше
  - **gte** - больше или равно
  - **lt** - меньше
  - **lte** - меньше или равно

### Доступные агрегатные функции свертки значений счетчиков

  - **count** - количество значений счетчика
  - **distinct** - количество **различных** значений счетчика
  - **sum** - сумма значений счетчика
  - **min** - минимальное значение счетчика
  - **max** - максимальное значение счетчика
  - **avg** - среднее значение счетчика

### Доступные форматы

  - **json** - (по умолчанию) JSON-текст собственной структуры
  - **prometheus** - формат Prometheus
  - **plain** - плоский текстовый формат без указания значений измерений

## Примеры запросов:

### Получение списка кластеров

```

iracli cluster list

```

## Серверы

### Получение списка серверов

```

iracli server list

```

## Информационные базы

### Получение списка ИБ

```

iracli infobase list

```

## Сеансы

### Получение списка сеансов

```

iracli session list

```
## Счетчики

### Получение списка счетчиков


```

 iracli counter list

```

### Получение всех счетчиков сеансов

#### Развернуто по всем измерениям

```

iracli counter session

или

iracli counter session --dim all

```

В формате Prometheus

```

iracli counter session --format prometheus

```

#### Свернуто по всем измерениям

Агрегатная функция по умолчанию (`count`)

```

iracli counter session --dim no

```

Агрегатная функция СУММА (`sum`)

```

iracli counter session --dim no aggregate sum

```

### Получение конкретного счетчика сеансов

#### Развернуто по всем измерениям

```

iracli counter session count --dim all

```

#### С отбором по типу клиента

```

iracli counter session count --filter eq_app_id=Designer

```

#### Свернуто по хосту и ИБ

Агрегатная функция СУММА (`sum`)

```

iracli counter session count --dim host&infobase --aggregate sum

```
