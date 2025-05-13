
ActiveRecord::Schema.define(version: 20250513120000) do

  create_table "usuario", force: :cascade do |t|
    t.string   "nome",           null: false
    t.string   "cpf",            null: false
    t.date     "data_nascimento",null: false
    t.string   "telefone",       null: false
    t.string   "tipo_usuario",   null: false
    t.string   "senha_hash",     null: false
    t.string   "otp_ativo"
    t.datetime "otp_expiracao"
    t.index ["cpf"], name: "index_usuario_on_cpf", unique: true
  end

  create_table "funcionario", force: :cascade do |t|
    t.integer  "id_usuario"
    t.string   "codigo_funcionario", null: false
    t.string   "cargo",              null: false
    t.integer  "id_supervisor"
    t.index ["id_usuario"], name: "index_funcionario_on_id_usuario"
    t.index ["id_supervisor"], name: "index_funcionario_on_id_supervisor"
  end

  create_table "cliente", force: :cascade do |t|
    t.integer "id_usuario"
    t.decimal "score_credito", precision: 5, scale: 2, default: 0
    t.index ["id_usuario"], name: "index_cliente_on_id_usuario"
  end

  create_table "endereco", force: :cascade do |t|
    t.integer  "id_usuario"
    t.string   "cep",         null: false
    t.string   "local",       null: false
    t.integer  "numero_casa", null: false
    t.string   "bairro",      null: false
    t.string   "cidade",      null: false
    t.string   "estado",      null: false, limit: 2
    t.string   "complemento"
    t.index ["id_usuario"], name: "index_endereco_on_id_usuario"
    t.index ["cep"], name: "index_endereco_on_cep"
  end

  create_table "agencia", force: :cascade do |t|
    t.string  "nome",           null: false
    t.string  "codigo_agencia", null: false
    t.integer "endereco_id"
    t.index ["codigo_agencia"], name: "index_agencia_on_codigo_agencia", unique: true
    t.index ["endereco_id"], name: "index_agencia_on_endereco_id"
  end

  create_table "conta", force: :cascade do |t|
    t.string   "numero_conta",  null: false
    t.integer  "id_agencia"
    t.decimal  "saldo",         precision: 15, scale: 2, default: 0, null: false
    t.string   "tipo_conta",    null: false
    t.integer  "id_cliente"
    t.datetime "data_abertura", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "status",        default: "ATIVA", null: false
    t.index ["numero_conta"], name: "index_conta_on_numero_conta", unique: true
  end

  create_table "conta_poupanca", force: :cascade do |t|
    t.integer  "id_conta"
    t.decimal  "taxa_rendimento", precision: 5, scale: 2, null: false
    t.datetime "ultimo_rendimento"
    t.index ["id_conta"], name: "index_conta_poupanca_on_id_conta", unique: true
  end

  create_table "conta_corrente", force: :cascade do |t|
    t.integer "id_conta"
    t.decimal "limite",          precision: 15, scale: 2, default: 0, null: false
    t.date    "data_vencimento",                           null: false
    t.decimal "taxa_manutencao", precision: 5, scale: 2, default: 0, null: false
    t.index ["id_conta"], name: "index_conta_corrente_on_id_conta", unique: true
  end

  create_table "conta_investimento", force: :cascade do |t|
    t.integer "id_conta"
    t.string  "perfil_risco", null: false
    t.decimal "valor_minimo", precision: 15, scale: 2, null: false
    t.decimal "taxa_rendimento_base", precision: 5, scale: 2, null: false
    t.index ["id_conta"], name: "index_conta_investimento_on_id_conta", unique: true
  end

  create_table "transacao", force: :cascade do |t|
    t.integer  "id_conta_origem"
    t.integer  "id_conta_destino"
    t.string   "tipo_transacao", null: false
    t.decimal  "valor", precision: 15, scale: 2, null: false
    t.datetime "data_hora", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "descricao"
    t.index ["data_hora"], name: "index_transacao_on_data_hora"
  end

  create_table "auditoria", force: :cascade do |t|
    t.integer  "id_usuario"
    t.string   "acao",       null: false
    t.datetime "data_hora", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text     "detalhes"
  end

  create_table "relatorio", force: :cascade do |t|
    t.integer  "id_funcionario"
    t.string   "tipo_relatorio", null: false
    t.datetime "data_geracao",   default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text     "conteudo",       null: false
  end

end
