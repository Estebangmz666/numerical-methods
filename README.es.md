# Numerical Methods Analysis Suite

![MATLAB](https://img.shields.io/badge/MATLAB-R2020a%2B-blue)
![Numerical Methods](https://img.shields.io/badge/topic-numerical%20methods-2f855a)
![Academic Project](https://img.shields.io/badge/type-academic%20project-805ad5)

[English Version](./README.md)

Proyecto academico de analisis numerico desarrollado en MATLAB. El repositorio implementa, compara y visualiza cinco familias de metodos numericos aplicadas a problemas de aproximacion, busqueda de raices, interpolacion, integracion y solucion de ecuaciones diferenciales ordinarias.

El flujo esta disenado para ser reproducible: al ejecutar `main.m`, el proyecto corre todos los modulos, genera graficas en alta resolucion, exporta tablas `.csv` y actualiza un reporte consolidado en `results/summary_report.txt`.

<p align="center">
  <img src="results/figures/problem_2_root_finding.png" alt="Bisection vs Newton-Raphson" width="48%">
  <img src="results/figures/problem_5_ode_solution.png" alt="Euler vs Runge-Kutta 4" width="48%">
</p>

## Tabla de Contenido

- [Objetivo](#objetivo)
- [Metodos implementados](#metodos-implementados)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Como ejecutar](#como-ejecutar)
- [Resultados destacados](#resultados-destacados)
- [Artefactos generados](#artefactos-generados)
- [Diseno tecnico](#diseno-tecnico)
- [Autores](#autores)

## Objetivo

Aplicar metodos numericos clasicos a problemas modelados desde un contexto de comportamiento, demanda y rendimiento de sistemas, comparando precision, convergencia y error experimental mediante salidas tabulares y visuales.

El proyecto cubre:

- Aproximacion local mediante series de Taylor.
- Busqueda de raices con metodos cerrados y abiertos.
- Interpolacion polinomica para estimar valores intermedios.
- Integracion numerica sobre funciones relacionadas con trafico.
- Solucion numerica de una EDO logistica.

## Metodos Implementados

| Categoria | Metodos | Archivos principales | Salida |
|---|---|---|---|
| Aproximacion | Serie de Taylor | `methods/taylor_approximation.m` | Error maximo, error medio y error cerca del punto de expansion |
| Raices | Biseccion y Newton-Raphson | `methods/bisection_method.m`, `methods/newton_raphson_method.m` | Raiz aproximada, iteraciones y residuo final |
| Interpolacion | Lagrange y Newton | `methods/lagrange_interpolation.m`, `methods/newton_interpolation.m` | Valores interpolados, coeficientes y diferencias divididas |
| Integracion | Regla del trapecio y Simpson | `methods/trapezoidal_rule.m`, `methods/simpson_rule.m` | Integral aproximada, tamano de paso y error absoluto |
| EDOs | Euler y Runge-Kutta 4 | `methods/euler_method.m`, `methods/runge_kutta_4.m` | Aproximacion final y error maximo absoluto |

## Estructura del Proyecto

```text
.
|-- main.m
|-- methods/
|   |-- bisection_method.m
|   |-- euler_method.m
|   |-- lagrange_interpolation.m
|   |-- newton_interpolation.m
|   |-- newton_raphson_method.m
|   |-- runge_kutta_4.m
|   |-- simpson_rule.m
|   |-- taylor_approximation.m
|   `-- trapezoidal_rule.m
|-- problems/
|   |-- problem_taylor.m
|   |-- problem_roots.m
|   |-- problem_interpolation.m
|   |-- problem_integration.m
|   `-- problem_ode.m
|-- results/
|   |-- figures/
|   |-- tables/
|   `-- summary_report.txt
|-- utils/
|   |-- ensure_results_directories.m
|   |-- save_figure_file.m
|   |-- save_table_file.m
|   `-- write_summary_report.m
`-- Entrega 1_ Planteamiento de Problemas y Contexto_ Metodos Numericos.pdf
```

## Como Ejecutar

### Requisitos

- MATLAB con soporte para `table`, `writetable` y `exportgraphics`.
- Recomendado: MATLAB R2020a o superior.

### Ejecucion local

Clona el repositorio:

```bash
git clone https://github.com/Estebangmz666/numerical_method_v1.git
cd numerical_method_v1
```

Abre MATLAB en la raiz del proyecto y ejecuta:

```matlab
main
```

El script principal se encarga de:

- Limpiar el entorno de ejecucion.
- Agregar `methods`, `problems` y `utils` al path de MATLAB.
- Crear automaticamente las carpetas de resultados cuando sea necesario.
- Ejecutar los cinco modulos de problemas.
- Exportar graficas, tablas y el reporte final.

## Resultados Destacados

| Problema | Hallazgo principal |
|---|---|
| Taylor | El polinomio de orden 6 reduce el error cerca del punto de expansion hasta `0.019097`. |
| Raices | Biseccion y Newton-Raphson convergen a `60.909843`; Newton-Raphson lo hace en 5 iteraciones. |
| Interpolacion | Lagrange y Newton producen los mismos valores en `x = 11` y `x = 13`, confirmando el mismo polinomio interpolante. |
| Integracion | Simpson con 24 subintervalos alcanza un error absoluto aproximado de `0.00018729`. |
| EDO | Runge-Kutta 4 con `h = 0.25` logra un error maximo aproximado de `0.00029596`, muy por debajo de Euler. |

<p align="center">
  <img src="results/figures/problem_1_taylor_approximation.png" alt="Taylor approximation" width="48%">
  <img src="results/figures/problem_3_interpolation.png" alt="Polynomial interpolation" width="48%">
</p>

<p align="center">
  <img src="results/figures/problem_4_numerical_integration.png" alt="Numerical integration" width="70%">
</p>

## Artefactos Generados

Todos los resultados se almacenan en `results/`:

- `results/summary_report.txt`: reporte consolidado con conclusiones y tablas principales.
- `results/figures/*.png`: visualizaciones exportadas en alta resolucion.
- `results/tables/*.csv`: metricas numericas para cada problema.

Tablas disponibles:

- `problem_1_taylor_metrics.csv`
- `problem_2_root_metrics.csv`
- `problem_3_interpolation_estimates.csv`
- `problem_3_lagrange_coefficients.csv`
- `problem_3_newton_divided_differences.csv`
- `problem_4_integration_metrics.csv`
- `problem_4_reference_integral.csv`
- `problem_5_ode_metrics.csv`

## Diseno Tecnico

El repositorio separa responsabilidades para mantener el codigo escalable y mantenible:

- `methods/` contiene implementaciones reutilizables de los metodos numericos.
- `problems/` define los casos aplicados, parametros, visualizaciones y tablas exportadas.
- `utils/` centraliza la creacion de carpetas, exportacion de figuras, exportacion de tablas y generacion del reporte consolidado.
- `main.m` actua como punto unico de entrada.

Las funciones principales retornan resultados y metadatos utiles para analizar convergencia, errores e iteraciones sin acoplar la logica numerica con la presentacion.

## Autores

Proyecto desarrollado para la asignatura de Analisis Numerico.

- Esteban Gomez Leon
- Juan Antonio Betancourt Parra

Universidad del Quindio, Programa de Ingenieria de Sistemas y Computacion.
