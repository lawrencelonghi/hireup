# Convenções de Código - Hireup!

## Git Commits
Formato: `tipo(escopo): mensagem`

Tipos:
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação
- `refactor`: Refatoração
- `test`: Testes
- `chore`: Manutenção

Exemplos:
```
feat(auth): implementar login com JWT
fix(alunos): corrigir validação de email
docs(readme): atualizar instruções de setup
```

## Nomenclatura

### Arquivos
- JavaScript: camelCase.js
- Go: snake_case.go 

### Variáveis e Funções

```javascript
// camelCase para variáveis e funções
const userName = 'João';
function getUserById() {}

// PascalCase para classes e construtores
class AlunoService {}

// UPPERCASE para constantes
const API_URL = 'https://api.myclass.com';

go
// camelCase para variáveis locais e parâmetros
userName := "João"
professorID := 123

// PascalCase para funções/métodos exportados
func GetUserByID() {}
func (s *AlunoService) ListarPorProfessor() {}

// camelCase para funções/métodos não exportados
func validarEmail() {}

// PascalCase para structs e interfaces
type Aluno struct {}
type AlunoService interface {}

// UPPERCASE para constantes
const API_URL = "https://api.myclass.com"
