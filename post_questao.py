import json
import requests
import os

path = os.getcwd()

def send(year):
  folder = os.listdir(path + '/' + year)

  for json_path in folder:
    if json_path == 'images':
      continue

    with open(year + '/' + json_path) as json_file:
      questao = json.load(json_file)
      questao_json = {
        'componente': questao['Componente'],
        'subarea': questao['Subarea'],
        'numero': questao["Numero"],
        'ano': questao['Ano'],
        'gabarito': questao['Resposta'],
        'alternativas': questao['Alternativas'],
        'imagens': questao['Imagens'],
        'enunciados': questao['Enunciado']
      }

      r = requests.post('http://localhost:3333/questoes', json=questao_json)  
      if r.status_code != 200:
        print('year: ' + year + ', json_path: ' + json_path)

send('2016')
send('2017')
send('2018')
send('2019')
