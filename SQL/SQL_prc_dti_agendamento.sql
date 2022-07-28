PROMPT CREATE OR REPLACE PROCEDURE dataintegra.prc_dti_agendamento
CREATE OR REPLACE PROCEDURE dataintegra.prc_dti_agendamento (p_result OUT NUMBER)
IS

/*
	P_RESULT  = 0  - SUCESSO
	P_RESULT  = 1  - ERRO
	P_RESULT  = 2  - HORARIO INDISPONIVEL
	P_RESULT  = 3  - SEM DADOS NA TABELA DE INTEGRAÇÃO
*/

CURSOR cPegaAgenda IS
	SELECT *
	FROM dataintegra.tbl_dti_agendamento
	WHERE tp_status = 'A';


CURSOR cVerificaHorario (p_cd_it_age_cent NUMBER) IS
	SELECT DISTINCT
	*
	FROM dbamv.IT_AGENDA_CENTRAL
	WHERE cd_it_agenda_central = p_cd_it_age_cent
	AND cd_paciente IS NULL
	AND nm_paciente IS NULL
	ORDER BY 1 DESC;


CURSOR c_exclui_agendamento (p_cd_it_age_cent NUMBER) IS
	SELECT DISTINCT
	*
	FROM IT_AGENDA_CENTRAL
	WHERE cd_it_agenda_central = p_cd_it_age_cent
	AND it_agenda_central.nm_paciente IS NOT NULL
	ORDER BY 1 DESC;


v_cPegaAgenda           cPegaAgenda%ROWTYPE;
v_cVerificaHorario      cVerificaHorario%ROWTYPE;
V_exclui_agendamento  	c_exclui_agendamento%ROWTYPE;
v_exclui              	NUMBER;
vSYSDATE                VARCHAR2(87) := SYSDATE;


BEGIN


	P_RESULT  := 3;
	DBMS_OUTPUT.PUT_LINE('LINHA 76');

	OPEN cPegaAgenda;
    FETCH cPegaAgenda INTO v_cPegaAgenda;
	CLOSE cPegaAgenda;
	DBMS_OUTPUT.PUT_LINE('LINHA 81');

	DBMS_OUTPUT.PUT_LINE('LINHA 83 v_cPegaAgenda.tp_movimento:  '|| v_cPegaAgenda.tp_movimento);
	IF v_cPegaAgenda.tp_movimento = 'I'  THEN

		OPEN cVerificaHorario(v_cPegaAgenda.cd_it_agenda_central);
		FETCH cVerificaHorario INTO v_cVerificaHorario;
		IF cVerificaHorario%NOTFOUND THEN
      DBMS_OUTPUT.PUT_LINE('LINHA 89 NDF');
			P_RESULT := 2 ;
			UPDATE dataintegra.tbl_dti_agendamento
			SET tp_status = 'E',
			ds_erro  = 'HORARIO INDISPONIVEL',
      dt_processado = vSYSDATE
			WHERE cd_dti_agenda = v_cPegaAgenda.cd_dti_agenda;
			COMMIT;
			RETURN;
		END IF;
		CLOSE cVerificaHorario;

		UPDATE DBAMV.IT_AGENDA_CENTRAL SET
		nr_carteira  	= v_cPegaAgenda.nr_carteira,
		nm_paciente  	= v_cPegaAgenda.nm_paciente,
		ds_email  		= v_cPegaAgenda.email,
		nr_fone 	  	= v_cPegaAgenda.nr_fone,
		dt_nascimento = v_cPegaAgenda.dt_nascimento
		WHERE cd_it_agenda_central = v_cPegaAgenda.cd_it_agenda_central;

		DBMS_OUTPUT.PUT_LINE('LINHA 101: '||SQL%ROWCOUNT);
		IF SQL%ROWCOUNT = 0
		THEN
			P_RESULT := 1;
			UPDATE dataintegra.tbl_dti_agendamento
			SET tp_status = 'E',
			ds_erro = 'ERRO NO AGENDAMENTO!  CD_IT_AGENDA_CENTRAL: '||v_cPegaAgenda.cd_it_agenda_central,
      dt_processado = vSYSDATE
			WHERE cd_dti_agenda = v_cPegaAgenda.cd_dti_agenda;
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('LINHA 118 ERRO NO AGENDAMENTO');

			ELSE

			DBMS_OUTPUT.PUT_LINE('LINHA 122 DEU BOM:  '||v_cPegaAgenda.cd_dti_agenda);
			P_RESULT := 0;
			UPDATE dataintegra.tbl_dti_agendamento
			SET tp_status = 'T',
      dt_processado = vSYSDATE
			WHERE cd_dti_agenda = v_cPegaAgenda.cd_dti_agenda;
			COMMIT;

		END IF;
	END IF;

	IF v_cPegaAgenda.tp_movimento = 'E'  THEN

        OPEN c_exclui_agendamento (v_cPegaAgenda.cd_it_agenda_central);
        FETCH c_exclui_agendamento   INTO V_exclui_agendamento;
		      IF  c_exclui_agendamento%FOUND THEN
			      v_exclui := 1;
		      END IF;
        CLOSE c_exclui_agendamento;
		DBMS_OUTPUT.PUT_LINE('LINHA 109 v_exclui : '||v_exclui);

		IF v_exclui = 1 then
			  DBMS_OUTPUT.PUT_LINE('cd_it_agenda_central: '||v_cPegaAgenda.cd_it_agenda_central);
		    UPDATE DBAMV.IT_AGENDA_CENTRAL
		    SET
		    NM_PACIENTE 	        = NULL,
		    DT_NASCIMENTO 		    = NULL,
		    CD_PACIENTE 		      = NULL,
		    CD_CONVENIO 		      = NULL,
		    CD_ITEM_AGENDAMENTO   = NULL,
        nr_carteira           = NULL,
        ds_email              = NULL,
        nr_fone               = NULL
		    WHERE cd_it_agenda_central = v_cPegaAgenda.cd_it_agenda_central;

		    IF SQL%ROWCOUNT <> 0 THEN
				P_RESULT := 0;

      	UPDATE dataintegra.tbl_dti_agendamento
				SET tp_status = 'T',
        dt_processado = vSYSDATE
				WHERE cd_dti_agenda = v_cPegaAgenda.cd_dti_agenda;
				COMMIT;

    	  END IF;
		END IF;
	END IF;
END;
/
