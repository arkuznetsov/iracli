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

## Команды

  - **<тип объектов> list** - список объектов
  - **<тип объектов> get** - данные объекта по указанному пути
  - **<тип объектов> counter** - значения счетчиков для <имя объекта>
  - **dump** - запись состояния кластера в файл

### Используемые типы объектов (`<тип объектов>`)

  - **cluster** - информация о кластерах
  - **server** - информация о рабочих серверах
  - **process** - информация о рабочих процессах
  - **infobase** - информация об информационных базах
  - **session** - информация о сеансах
  - **connection** - информация о соединениях

## Доступные параметры команд

### Доступные параметры команды получения списка объектов кластера (`<тип объектов> list`)

  - **--field <имена полей>** - имена полей запрашиваемого типа объекта, которые попадут в результат, имена полей разделяются запятыми (`--field _all` - попадут все поля)
  - **--filter <имя поля>_<операция сравнения>=<значение поля>** - условие <операция сравнения> (фильтр) по значению полей <имя поля>, условия разделяются запятыми
  - **--sort <имена полей>** - сортировка по значениям полей, имена полей разделяются запятыми
  - **--top <количество>** - отбор <количество> с максимальным значением поля, указанного в параметре `--top-field`
  - **--top-field** - поле для отбора `top` первых объектов

### Доступные параметры команды получения данных объекта (`<тип объектов> list`)

  - **--id <GUID или метка объекта>** - идентификатор объекта (GUID) или метка объекта
  - **--field** - имена полей запрашиваемого объекта, которые попадут в результат (`--field _all` - попадут все поля)
  - **--property <имя поля>** - выводимое свойство объекта
  - **--format <формат>** - формат вывода результата (json|prometheus|plain)

### Доступные поля запроса счетчиков (`<тип объектов> counter>`)

  - **--counter-settings <путь к файлу>** - путь к файлу настроек счетчиков, если не указан, беруться стандартные настройки из макета `/config/counters.json`
  - **--counter <имя поля счетчика>** - имя поля объекта из которого получается значение счетчика, если не указано, то получаются значения всех полей счетчика
  - **--dim <имена полей>** - имя измерения счетчика по которым выполняется свертка значения счетчика (`dim _all` - попадут все измерения счетчика)
  - **--filter <имя поля>_<операция сравнения>=<значение поля>** - условие <операция сравнения> (фильтр) по значению полей <имя поля>, условия разделяются запятыми
  - **--sort <имена полей>** - сортировка по значениям полей, имена полей разделяются запятыми
  - **--top <количество>** - отбор <количество> первых значений счетчика с максимальным значением
  - **--aggregate <агрегатная функция>** - агрегатная функция свертки значений счетчика
  - **--format** - формат вывода результата (json|prometheus|plain)

### Формат меток типов объектов кластера (`<метка объекта>`)

  - **cluster** - <адрес сервера>:<порт сервера>
  - **server** - <адрес агента>:<порт агента>
  - **process** - <адрес агента>:<порт процесса>
  - **infobase** - <имя информационной базы>
  - **session** - <имя информационной базы>:<номер сеанса>
  - **connection** - <адрес агента>:<порт процесса>:<номер соединения или имя приложения для соединений с `conn-id = 0`>

### Доступные операции сравнения фильтров (`<операция сравнения>`)

  - **eq** - равно (может не указываться), для строк выполняется без учета регистра
  - **neq** - не равно, для строк выполняется без учета регистра
  - **gt** - больше
  - **gte** - больше или равно
  - **lt** - меньше
  - **lte** - меньше или равно

### Доступные агрегатные функции свертки значений счетчиков (`<агрегатная функция>`)

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

## Примеры комманд:

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

iracli counter session --dim _all

```

В формате Prometheus

```

iracli counter session --format prometheus

```

#### Свернуто по всем измерениям

Агрегатная функция по умолчанию (`count`)

```

iracli counter session --dim _no

```

Агрегатная функция СУММА (`sum`)

```

iracli counter session --dim _no aggregate sum

```

### Получение конкретного счетчика сеансов

#### Развернуто по всем измерениям

```

iracli counter session count --dim _all

```

#### С отбором по типу клиента

```

iracli counter session count --filter app-id_eq=Designer

```

#### Свернуто по хосту и ИБ

Агрегатная функция СУММА (`sum`)

```

iracli counter session count --dim host,infobase --aggregate sum

```
