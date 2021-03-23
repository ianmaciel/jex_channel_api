/*
 * Copyright (c) 2021 Ian Koerich Maciel
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

class JExModelFixture {
  static const String jsObject =
      '''{dias:[{diferencaHorasFormatado:"00:00",isDiaUtil:false,diferencaHoras:0.0,nomeDiaSemana:"Dom",apontado:0.0,horasRecurso:0.0,dataRecursoHabilitada:false,dia:"28/02/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Seg",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"01/03/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Ter",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"02/03/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Qua",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"03/03/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Qui",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"04/03/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Sex",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"05/03/2021"},{diferencaHorasFormatado:"00:00",isDiaUtil:false,diferencaHoras:0.0,nomeDiaSemana:"Sab",apontado:0.0,horasRecurso:0.0,dataRecursoHabilitada:false,dia:"06/03/2021"}],inicioFormatado:"28/02/2021",fimFormatado:"07/03/2021"}''';

  static const String expectedJson =
      '''{"dias":[{"diferencaHorasFormatado":"00:00","isDiaUtil":false,"diferencaHoras":0.0,"nomeDiaSemana":"Dom","apontado":0.0,"horasRecurso":0.0,"dataRecursoHabilitada":false,"dia":"28/02/2021"},{"diferencaHorasFormatado":"08:00","isDiaUtil":true,"diferencaHoras":8.0,"eventos":[],"nomeDiaSemana":"Seg","apontado":0.0,"horasRecurso":8.0,"dataRecursoHabilitada":true,"dia":"01/03/2021"},{"diferencaHorasFormatado":"08:00","isDiaUtil":true,"diferencaHoras":8.0,"eventos":[],"nomeDiaSemana":"Ter","apontado":0.0,"horasRecurso":8.0,"dataRecursoHabilitada":true,"dia":"02/03/2021"},{"diferencaHorasFormatado":"08:00","isDiaUtil":true,"diferencaHoras":8.0,"eventos":[],"nomeDiaSemana":"Qua","apontado":0.0,"horasRecurso":8.0,"dataRecursoHabilitada":true,"dia":"03/03/2021"},{"diferencaHorasFormatado":"08:00","isDiaUtil":true,"diferencaHoras":8.0,"eventos":[],"nomeDiaSemana":"Qui","apontado":0.0,"horasRecurso":8.0,"dataRecursoHabilitada":true,"dia":"04/03/2021"},{"diferencaHorasFormatado":"08:00","isDiaUtil":true,"diferencaHoras":8.0,"eventos":[],"nomeDiaSemana":"Sex","apontado":0.0,"horasRecurso":8.0,"dataRecursoHabilitada":true,"dia":"05/03/2021"},{"diferencaHorasFormatado":"00:00","isDiaUtil":false,"diferencaHoras":0.0,"nomeDiaSemana":"Sab","apontado":0.0,"horasRecurso":0.0,"dataRecursoHabilitada":false,"dia":"06/03/2021"}],"inicioFormatado":"28/02/2021","fimFormatado":"07/03/2021"}''';
}
