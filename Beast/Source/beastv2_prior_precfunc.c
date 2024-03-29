#include "abc_000_macro.h"
#include "abc_000_warning.h"

#include <math.h>
#include <string.h>

#include "abc_mcmc.h"
#include "abc_ts_func.h"
#include "abc_mat.h"
#include "abc_math.h"    //sumlog, sum_log_diagv2, fastlog
#include "abc_rand.h"
#include "abc_mem.h"
#include "abc_blas_lapack_lib.h"

#include "globalvars.h"
#include "beastv2_header.h"
#include "beastv2_prior_precfunc.h" 


 



void InitPrecPriorMEM(BEAST2_MODEL_PTR model, BEAST2_OPTIONS_PTR opt, MemPointers * MEM) {

	#define MODEL (*model)

	I08 precType = opt->prior.precPriorType;
	if (precType==ConstPrec || precType == UniformPrec) {
		// 0: Use a constant precison value
		// 1: Use a uniform precision value for all terms

		MODEL.nPrec      = 1L;    // this number is needed to set "RNDGAMMA_END = RNDGAMMA + MAX_RAND_NUM - MODEL.nPrec-1L"
		MODEL.precVal    = opt->prior.precValue;	
		MODEL.logPrecVal = logf(MODEL.precVal);

		//MODE.precXtXDiag and precXtXDiag_prop will be used in chol_addCol
		//To make a a consistent API for chol_addCol, they are pointed to model.prec when prec is a single scalar.
		MODEL.curr.precXtXDiag = &MODEL.precVal; 
		MODEL.prop.precXtXDiag = &MODEL.precVal;
		
		
		// All the bases share the same prec, so they don'tY have their own versions.
		for (int i = 0; i < MODEL.NUMBASIS; i++) {
			MODEL.b[i].nPrec      = -9999L;
			MODEL.b[i].offsetPrec = -9999L;
		}	
		MODEL.curr.nTermsPerPrecGrp = NULL;
		MODEL.prop.nTermsPerPrecGrp = NULL;
	}
	else if (precType == ComponentWise)
	{
		//2: Use varying precisions values for different terms and orders
	
		MODEL.nPrec      = MODEL.NUMBASIS;     // this number is needed to set "RNDGAMMA_END = RNDGAMMA + MAX_RAND_NUM - MODEL.nPrec-1L"
		MODEL.precVec    = MyALLOC(*MEM,   MODEL.nPrec*2, F32, 0);
		MODEL.logPrecVec = MODEL.precVec + MODEL.nPrec;
		// Initial precision values in this vector is only used for the first chain of the first pixel
		// and all the other subsquent chains or pixels will be using whatever existing values are left 
		// from the previous background. This may have some unintended consequences.
		F32 precValue = opt->prior.precValue;
		r_ippsSet_32f(precValue,       MODEL.precVec,    MODEL.nPrec);
		r_ippsSet_32f(logf(precValue), MODEL.logPrecVec, MODEL.nPrec);

		I32 K_MAX = opt->prior.K_MAX;
		MODEL.curr.precXtXDiag = MyALLOC(*MEM, K_MAX, F32, 64);
		MODEL.prop.precXtXDiag = MyALLOC(*MEM, K_MAX, F32, 64);

		// The indices to precVec or logPrecVec are just the basisID, so no offset is needed here
		for (int i = 0; i < MODEL.NUMBASIS; i++) {
			BEAST2_BASIS_PTR b = MODEL.b + i;
			b->nPrec      = -9999L;
			b->offsetPrec = -9999L;
		}
		MODEL.curr.nTermsPerPrecGrp = NULL;
		MODEL.prop.nTermsPerPrecGrp = NULL;
	}
 	else if (precType == OrderWise)
	{
		//2: Use varying precisions values for different terms and orders
		I32    cumsum = 0;
		for (int i = 0; i < MODEL.NUMBASIS; i++) {
			BEAST2_BASIS_PTR b = MODEL.b + i;
			if      (b->type == SEASONID)		b->nPrec = b->prior.maxOrder;
			else if (b->type == DUMMYID)		b->nPrec = b->bConst.dummy.period;
			else if (b->type == SVDID)		    b->nPrec = b->prior.maxOrder;
			else if (b->type == TRENDID)		b->nPrec = b->prior.maxOrder + 1;
			else if (b->type == OUTLIERID) 	b->nPrec = 1;
			
			b->offsetPrec = cumsum;
			cumsum		 += b->nPrec;
		}
		MODEL.nPrec      = cumsum;

		//MODEL.precVec    = MyALLOC(*MEM, MODEL.nPrec, F32, 64); MODEL.logPrecVec = MyALLOC(*MEM, MODEL.nPrec, F32, 64);
		MODEL.precVec    = MyALLOC(*MEM, MODEL.nPrec * 2, F32, 64); 
		MODEL.logPrecVec = MODEL.precVec + MODEL.nPrec;

		// TODO: Initial precision values in this vector is only used for the first chain of the first pixel
		// and all the other subsquent chains or pixels will be using whatever existing values are left 
		// from the previous background. This may have some unintended consequences.
		F32 precValue = opt->prior.precValue;
		r_ippsSet_32f(precValue,       MODEL.precVec,    MODEL.nPrec);
		r_ippsSet_32f(logf(precValue), MODEL.logPrecVec, MODEL.nPrec);

		// MODEL.curr.nTermsPerPrecGrp = MyALLOC(*MEM, MODEL.nPrec, I08, 64); 		MODEL.prop.nTermsPerPrecGrp = MyALLOC(*MEM, MODEL.nPrec, I08, 64);
		MODEL.curr.nTermsPerPrecGrp = MyALLOC(*MEM, MODEL.nPrec * 2, I08, 64); 	
		MODEL.prop.nTermsPerPrecGrp = MODEL.curr.nTermsPerPrecGrp + MODEL.nPrec;

		// MODEL.curr.precXtXDiag = MyALLOC(*MEM, MAX_K, F32, 64);		MODEL.prop.precXtXDiag = MyALLOC(*MEM, MAX_K, F32, 64);
		I32 K_MAX = opt->prior.K_MAX;
		MODEL.curr.precXtXDiag = MyALLOC(*MEM, K_MAX * 2, F32, 64);
		MODEL.prop.precXtXDiag = MODEL.curr.precXtXDiag + K_MAX;
	}
	/*
	else if (precType == ComponentWise)
	{
		//2: Use varying precisions values for different terms and orders
		I32    cumsum = 0;
		for (int i = 0; i < MODEL.NUMBASIS; i++) {
			BEAST2_BASIS_PTR b = MODEL.b + i;

			if (b->type == SEASONID || b->type == DUMMYID) 	{
				b->nPrec = 1,	b->offsetPrec = 0;
				cumsum = 1;
			}
			else if (b->type == TRENDID){
				b->nPrec = 1;
				b->offsetPrec = 0;
				cumsum = 1;
			}			
			else if (b->type == OUTLIERID) {
				MODEL.b[i].nPrec = 2;
				MODEL.b[i].offsetPrec = 1;
				cumsum +=2 ;
			}			
		}
		MODEL.nPrec = cumsum;

		MODEL.precVec    = MyALLOC(*MEM, MODEL.nPrec*2, F32, 0);
		MODEL.logPrecVec = MODEL.precVec + MODEL.nPrec;
		// Initial precision values in this vector is only used for the first chain of the first pixel
		// and all the other subsquent chains or pixels will be using whatever existing values are left 
		// from the previous background. This may have some unintended consequences.
		F32 precValue = opt->prior.precValue;
		r_ippsSet_32f(precValue,       MODEL.precVec, MODEL.nPrec);
		r_ippsSet_32f(logf(precValue), MODEL.logPrecVec, MODEL.nPrec);

		MODEL.curr.nTermsPerPrecGrp  = 1;
		MODEL.prop.nTermsPerPrecGrp = 2;

		MODEL.curr.precXtXDiag      = MyALLOC(*MEM, MAX_K, F32, 64);
		MODEL.prop.precXtXDiag = MyALLOC(*MEM, MAX_K, F32, 64);

	}
	*/
}


void GetNumTermsPerPrecGrp_prec012(BEAST2_MODEL_PTR model) {
	// [0:ConstPrec, 1:UniformPrec, 2:ComponentWise], 3:OrderWise
	return;
}


void GetNumTermsPerPrecGrp_prec3(BEAST2_MODEL_PTR  model) { 
	// 0:ConstPrec, 1:UniformPrec, 2:ComponentWise, [3:OrderWise]
	memset(MODEL.curr.nTermsPerPrecGrp, 0, MODEL.nPrec);

	for (int id = 0; id < MODEL.NUMBASIS; id++) {
		I08PTR   nTermsPerGrp = MODEL.curr.nTermsPerPrecGrp + MODEL.b[id].offsetPrec;
		U08PTR   termType     = MODEL.b[id].termType;
		for (int k = 0; k < MODEL.b[id].K; k++) {	 
			nTermsPerGrp[ termType[k]-1 ]++;
		}
	}

}

// [0:ConstPrec, 1:UniformPrec], 2:ComponentWise, 3:OrderWise
void GetXtXPrecDiag_prec01(BEAST2_MODEL_PTR model) {return;}


void GetXtXPrecDiag_prec2(BEAST2_MODEL_PTR model) {
	// 0:ConstPrec, 1:UniformPrec, [2:ComponentWise], 3:OrderWise

	// Getting not the prec vector but a base prec vect that needs to be scaled by the true prec	
	F32PTR precXtXDiag = MODEL.curr.precXtXDiag;
	for (int id = 0; id < MODEL.NUMBASIS; id++) {
		//F32PTR    precVec = MODEL.precVec + MODEL.b[id].offsetPrec;
		// For componentwise precision type, precVec takes only one value for each componet,
		// so id can be used as an index rather than using b[id].offsetPrec
		F32		  prec    = MODEL.precVec[id];  
		for (int k = 0; k < MODEL.b[id].K; k++) {
			*precXtXDiag++ = prec;
		}
	}
}

void GetXtXPrecDiag_prec3( BEAST2_MODEL_PTR model) {
	// 0:ConstPrec, 1:UniformPrec, 2:ComponentWise, [3:OrderWise]
	F32PTR precXtXDiag = MODEL.curr.precXtXDiag;
	for (int id = 0; id < MODEL.NUMBASIS; id++) {
		U08PTR    termType = MODEL.b[id].termType;
		F32PTR    prec     = MODEL.precVec + MODEL.b[id].offsetPrec;
		for (int k = 0; k < MODEL.b[id].K; k++) {
			*precXtXDiag++ = prec[termType[k] - 1];
		}
	} 
}


void UpdateXtXPrec_nTermsPerGrp_prec01(BEAST2_MODEL_PTR model, BEAST2_BASIS_PTR basis, NEWTERM_PTR new){
	// [0:ConstPrec, 1:UniformPrec], 2:ComponentWise, 3:OrderWise
	return; 
}
void UpdateXtXPrec_nTermsPerGrp_prec2(BEAST2_MODEL_PTR model, BEAST2_BASIS_PTR basis, NEWTERM_PTR new) {
	// 0:ConstPrec, 1:UniformPrec, [2:ComponentWise], 3:OrderWise

	I32 Kold = MODEL.curr.K;
	SCPY(new->k1 - 1,        MODEL.curr.precXtXDiag,               MODEL.prop.precXtXDiag);
	SCPY(Kold - new->k2_old, MODEL.curr.precXtXDiag + new->k2_old, MODEL.prop.precXtXDiag + new->k2_new);

	
	//F32PTR  precVec  = MODEL.precVec     + basis->offsetPrec;
	//F32		prec	= *precVec;

	// basis id is used to index the prec value
	I32 idx  = basis - model->b;
	F32 prec = MODEL.precVec[idx];

	F32PTR  precXtXDiag = MODEL.prop.precXtXDiag;
	for (int k = new->k1 ; k < new->k2_new; k++) {
		precXtXDiag[k - 1] = prec;		
	}
}

void UpdateXtXPrec_nTermsPerGrp_prec3(BEAST2_MODEL_PTR model, BEAST2_BASIS_PTR basis, NEWTERM_PTR new)
{
	 //  3:OrderWise

	I32 Kold = MODEL.curr.K;
	SCPY(new->k1 - 1,        MODEL.curr.precXtXDiag,               MODEL.prop.precXtXDiag);
	SCPY(Kold - new->k2_old, MODEL.curr.precXtXDiag + new->k2_old, MODEL.prop.precXtXDiag + new->k2_new);

	F32PTR  precXtXDiag = MODEL.prop.precXtXDiag + new->k1 - 1;
	F32PTR  prec        = MODEL.precVec          + basis->offsetPrec;

	if (basis->type == SEASONID){
		for (int i = 0; i < new->numSeg; i++) {
			for (int order = new->SEG[i].ORDER1; order <= new->SEG[i].ORDER2; order++) {
				*precXtXDiag++ = prec[order - 1];
				*precXtXDiag++ = prec[order - 1];
			}
		}
	}
	else if (basis->type == TRENDID) {
		for (int i = 0; i < new->numSeg; i++) {
			for (int order = new->SEG[i].ORDER1; order <= new->SEG[i].ORDER2; order++) {
				*precXtXDiag++ = prec[order];
			}
		}
	}
	else if (basis->type == OUTLIERID) {
		//new->numSeg == Knewterm
		for (int i = 0; i < new->numSeg; i++)
			precXtXDiag[i] = prec[0];
	}

	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////

	#undef  NEW   //undo #define NEW(class_def)  R_do_new_object(class_def)
	#define NEW (*new)

	memcpy(MODEL.prop.nTermsPerPrecGrp, MODEL.curr.nTermsPerPrecGrp, MODEL.nPrec);

	I32 k1    = NEW.k1     - basis->Kbase;
	I32 k2old = NEW.k2_old - basis->Kbase;
	I32 k2new = NEW.k2_new - basis->Kbase;
	I32 nPrec = basis->nPrec;
	U08PTR termType = basis->termType;
	I08PTR numTerms = MODEL.prop.nTermsPerPrecGrp + basis->offsetPrec;
	memset(numTerms, 0, nPrec);


	if (basis->type == SEASONID || basis->type == TRENDID) {
		for (int i = 1; i <= k1 - 1; i++) {
			numTerms[termType[i - 1] - 1]++;
		}
		I32 Kbasis_old = basis->K;
		for (int i = k2old + 1; i <= Kbasis_old; i++) {
			numTerms[termType[i - 1] - 1]++;
		}

		if (basis->type == SEASONID) {			
			for (int i = 0; i < NEW.numSeg; i++) {
				for (int order = new->SEG[i].ORDER1; order <= new->SEG[i].ORDER2; order++) {
					numTerms[order - 1] += 2;
				}
			}
		}
		else
		{
			for (int i = 0; i < NEW.numSeg; i++) {
				for (int order = new->SEG[i].ORDER1; order <= new->SEG[i].ORDER2; order++) {
					numTerms[order ] += 1;
				}
			}

		}
	 
	}
	else if (basis->type == OUTLIERID) {
		numTerms[0] = NEW.nKnot_new;
	}
#undef  NEW

}

void ResamplePrecValues_prec0(BEAST2_MODEL_PTR model, BEAST2_HyperPar* hyperPar, VOID_PTR stream) {
	// 0:ConstPrec
	return;
}

void ResamplePrecValues_prec1(BEAST2_MODEL_PTR model, BEAST2_HyperPar * hyperPar, VOID_PTR stream) {
	// 1:UniformPrec

	I32 K    = MODEL.curr.K;
	F32 sumq = DOT(K, MODEL.beta, MODEL.beta);

	r_vsRngGamma(VSL_RNG_METHOD_GAMMA_GNORM_ACCURATE, (*(VSLStreamStatePtr*)stream), 1L, &(model->precVal), (hyperPar->del_1 + K * 0.5f), 0, 1.f);
	F32 newPrecVal     = model->precVal / (hyperPar->del_2 + 0.5f * sumq / model->sig2);
	model->precVal     = newPrecVal > MIN_PREC_VALUE? newPrecVal: model->precVal;
	model->logPrecVal  = logf(model->precVal);
		 
}
void ResamplePrecValues_prec2(BEAST2_MODEL_PTR model, BEAST2_HyperPar * hyperPar, VOID_PTR stream) {
	
	// 0:ConstPrec, 1:UniformPrec, [2:ComponentWise], 3:OrderWise

		for (int id = 0; id < MODEL.NUMBASIS; id++) {
			BEAST2_BASIS_PTR	basis	= &MODEL.b[id];
			F32PTR				beta	= MODEL.beta + basis->Kbase;
			I32                 K		= basis->K;

			if (K <= 0) continue;

			F32		sumq = DOT(K, beta, beta);
			r_vsRngGamma(VSL_RNG_METHOD_GAMMA_GNORM_ACCURATE, (*(VSLStreamStatePtr*)stream), 1, &(MODEL.precVec[id]), (hyperPar->del_1 + K * 0.5f), 0, 1.f);
			F32 newPrecVal          = MODEL.precVec[id] / (hyperPar->del_2 + 0.5f * sumq / MODEL.sig2);
			MODEL.precVec[id]		= newPrecVal > MIN_PREC_VALUE ? newPrecVal : MODEL.precVec[id];
			MODEL.logPrecVec[id]	= logf(MODEL.precVec[id]);
		}

}
void ResamplePrecValues_prec3(BEAST2_MODEL_PTR model, BEAST2_HyperPar * hyperPar, VOID_PTR stream) {

	// 0:ConstPrec, 1:UniformPrec, 2:ComponentWise, [3:OrderWise]

	for (int id = 0; id < MODEL.NUMBASIS; id++) {
		BEAST2_BASIS_PTR basis = &MODEL.b[id];
		F32PTR prec     = MODEL.precVec    + basis->offsetPrec;;
		F32PTR logPrec  = MODEL.logPrecVec + basis->offsetPrec;;
		U08PTR termType = basis->termType;

		F32PTR beta	= MODEL.beta + basis->Kbase;
		for (int i = 1; i <= basis->nPrec; i++) {
			F32 sumq	= 0;
			I32 K		= 0;
			for (int j = 0; j < basis->K; j++) {
				if (termType[j] == i) {
					sumq += beta[j]*beta[j]; K++;
				}
			}
			if (K > 0) {
				r_vsRngGamma(VSL_RNG_METHOD_GAMMA_GNORM_ACCURATE, (*(VSLStreamStatePtr*)stream), 1, &prec[i - 1], (hyperPar->del_1 + K * 0.5f), 0, 1.f);
				F32 newPrecVal = prec[i - 1] / (hyperPar->del_2 + 0.5f * sumq / MODEL.sig2);
				prec[i - 1]    = newPrecVal > MIN_PREC_VALUE ? newPrecVal : prec[i - 1];
				logPrec[i - 1] = logf(prec[i - 1]);
			}
		}

	}
}

void IncreasePrecValues_prec0(BEAST2_MODEL_PTR model) {
	// 0:ConstPrec
	return;
}

void IncreasePrecValues_prec1(BEAST2_MODEL_PTR model) {
	// 1:UniformPrec
	model->precVal     = model->precVal+ model->precVal;
	model->logPrecVal  = logf(model->precVal);

}
 
void IncreasePrecValues_prec2(BEAST2_MODEL_PTR model) {
	// 0:ConstPrec, 1:UniformPrec, [2:ComponentWise], 3:OrderWise
	for (int id = 0; id < MODEL.NUMBASIS; ++id) {
		MODEL.precVec[id]    = MODEL.precVec[id]+ MODEL.precVec[id];
		MODEL.logPrecVec[id] = logf(MODEL.precVec[id]);
	}

}

void IncreasePrecValues_prec3(BEAST2_MODEL_PTR model) {

	// 0:ConstPrec, 1:UniformPrec, 2:ComponentWise, [3:OrderWise]

	for (int id = 0; id < MODEL.NUMBASIS; ++id) {
		BEAST2_BASIS_PTR basis = &MODEL.b[id];
		F32PTR prec    = MODEL.precVec + basis->offsetPrec;;
		F32PTR logPrec = MODEL.logPrecVec + basis->offsetPrec;;
		U08PTR termType = basis->termType;

		F32PTR beta = MODEL.beta + basis->Kbase;
		for (int i = 1; i <= basis->nPrec; i++) {
			I32 K   = 0;
			for (int j = 0; j < basis->K; j++) {
				if (termType[j] == i) {
					K++;
				}
			}
			if (K > 0) {								
				prec[i - 1]    = prec[i - 1]+ prec[i - 1];
				logPrec[i - 1] = logf(prec[i - 1]);
			}
		}

	}
}


void ComputeMargLik_prec01(BEAST2_MODELDATA_PTR data, BEAST2_MODEL_PTR model,	BEAST2_YINFO_PTR yInfo, 
								 BEAST2_HyperPar_PTR hyperPar)
{
	 I32 K = data->K;
	 solve_U_as_LU_invdiag_sqrmat(data->cholXtX, data->XtY, data->beta_mean, K);
	//Compute alpha2_star: Two ways to compute alpha2_star: YtY-m*V*m
	/* ---THE FIRST WAY---
			//GlobalMEMBuf_1st = Xnewterm + K_newTerm*Npad;
			r_cblas_scopy(KNEW, beta_mean_prop, 1, GlobalMEMBuf_2nd, 1);
			//cblas_dtrmv(const CBLAS_LAYOUT Layout, const CBLAS_UPLO uplo, const CBLAS_TRANSPOSE trans, const CBLAS_DIAG diag, const MKL_INT n, const double *a, const MKL_INT lda, double *x, const MKL_INT incx);
			r_cblas_strmv(CblasColMajor, CblasUpper, CblasNoTrans, CblasNonUnit, KNEW, cholXtX_prop, KNEW, GlobalMEMBuf_2nd, 1);
			//double cblas_ddot (const MKL_INT n, const double *x, const MKL_INT incx, const double *y, const MKL_INT incy);
			basis_prop->alpha2_star = yInfo.YtY - DOT(KNEW, GlobalMEMBuf_2nd, GlobalMEMBuf_2nd);
	*/
	/*---THE SECOND WAY-- */
	F32 alpha2_star			=  (yInfo->YtY_plus_alpha2Q[0] - DOT(K, data->XtY,data->beta_mean))*0.5;

	//half_log_det_post  = sum(log(1. / diag(U)))	 
	//half_log_det_post  = -sum_log_diagv2(MODEL.prop.cholXtX, KNEW);
	F32 half_log_det_post = sum_log_diagv2(data->cholXtX, K);

	////Copy the diagonal of P_U to buf
	// vmsLn(KNEW, GlobalMEMBuf_1st, GlobalMEMBuf_1st, VML_HA);
	// ippsSum_32f(GlobalMEMBuf_1st, KNEW, &FLOAT_SHARE.half_log_det_post, ippAlgHintFast);
	// r_ippsSumLn_32f(GlobalMEMBuf_2nd, KNEW, &half_log_det_post);	

	//half_log_det_prior = -0.5 * (k_SN * log(prec(1)) + length(k_const_terms) * log(prec(2)) + length(linear_terms) * log(prec(3)));
	// F32 half_log_det_prior = -0.5f * KNEW * *modelPar.LOG_PREC[0]

	F32 half_log_det_prior = -0.5f*model->logPrecVal*K;		

	//log_ML = half_log_det_post - half_log_det_prior - (n / 2 + b) * log(a + a_star / 2);
	F32 marg_lik   = half_log_det_post  -half_log_det_prior	- yInfo->alpha1_star * fastlog(alpha2_star);

	data->alpha2_star = alpha2_star;
	data->marg_lik   = marg_lik;
}
void ComputeMargLik_prec2(BEAST2_MODELDATA_PTR data, BEAST2_MODEL_PTR model,	BEAST2_YINFO_PTR yInfo,
								BEAST2_HyperPar_PTR hyperPar) {

	I32 K = data->K;
	solve_U_as_LU_invdiag_sqrmat(data->cholXtX, data->XtY, data->beta_mean, K);	
	//Compute alpha2_star: Two ways to compute alpha2_star: YtY-m*V*m
	/* ---THE FIRST WAY---
			//GlobalMEMBuf_1st = Xnewterm + K_newTerm*Npad;
			r_cblas_scopy(KNEW, beta_mean_prop, 1, GlobalMEMBuf_2nd, 1);
			//cblas_dtrmv(const CBLAS_LAYOUT Layout, const CBLAS_UPLO uplo, const CBLAS_TRANSPOSE trans, const CBLAS_DIAG diag, const MKL_INT n, const double *a, const MKL_INT lda, double *x, const MKL_INT incx);
			r_cblas_strmv(CblasColMajor, CblasUpper, CblasNoTrans, CblasNonUnit, KNEW, cholXtX_prop, KNEW, GlobalMEMBuf_2nd, 1);
			//double cblas_ddot (const MKL_INT n, const double *x, const MKL_INT incx, const double *y, const MKL_INT incy);
			basis_prop->alpha2_star = yInfo.YtY - DOT(KNEW, GlobalMEMBuf_2nd, GlobalMEMBuf_2nd);
	*/

	/*---THE SECOND WAY-- */
	F32 alpha2_star      = ( yInfo->YtY_plus_alpha2Q[0] - DOT(K, data->XtY, data->beta_mean) ) * 0.5;
	//half_log_det_post  = sum(log(1. / diag(U)))	 
	//half_log_det_post  = -sum_log_diagv2(MODEL.prop.cholXtX, KNEW);
	F32 half_log_det_post = sum_log_diagv2(data->cholXtX, K);

	////Copy the diagonal of P_U to buf
	// vmsLn(KNEW, GlobalMEMBuf_1st, GlobalMEMBuf_1st, VML_HA);
	// ippsSum_32f(GlobalMEMBuf_1st, KNEW, &FLOAT_SHARE.half_log_det_post, ippAlgHintFast);
	// r_ippsSumLn_32f(GlobalMEMBuf_2nd, KNEW, &half_log_det_post);	

	//half_log_det_prior = -0.5 * (k_SN * log(prec(1)) + length(k_const_terms) * log(prec(2)) + length(linear_terms) * log(prec(3)));
	// F32 half_log_det_prior = -0.5f * KNEW * *modelPar.LOG_PREC[0]

	/***********************PrecPiorType=2*******************************/	 	
	F32 half_log_det_prior	= data->precXtXDiag[0]*model->b[0]. K;
	if (model->NUMBASIS == 2) 	half_log_det_prior += data->precXtXDiag[1] * model->b[1].K;		
	else						half_log_det_prior += data->precXtXDiag[1] * model->b[1].K+ data->precXtXDiag[2] * model->b[2].K;
	half_log_det_prior = -0.5 * half_log_det_prior;
	/***********************PrecPiorType=2*******************************/

	//log_ML = half_log_det_post - half_log_det_prior - (n / 2 + b) * log(a + a_star / 2);
	F32 marg_lik = half_log_det_post- half_log_det_prior- yInfo->alpha1_star* fastlog(alpha2_star);

	data->alpha2_star = alpha2_star;
	data->marg_lik   = marg_lik;
}
void ComputeMargLik_prec3(BEAST2_MODELDATA_PTR data, BEAST2_MODEL_PTR model,BEAST2_YINFO_PTR yInfo, 
	BEAST2_HyperPar_PTR hyperPar) {

	I32 K = data->K;
	solve_U_as_LU_invdiag_sqrmat(data->cholXtX, data->XtY, data->beta_mean, K);
	//Compute alpha2_star: Two ways to compute alpha2_star: YtY-m*V*m
	/* ---THE FIRST WAY---
			//GlobalMEMBuf_1st = Xnewterm + K_newTerm*Npad;
			r_cblas_scopy(KNEW, beta_mean_prop, 1, GlobalMEMBuf_2nd, 1);
			//cblas_dtrmv(const CBLAS_LAYOUT Layout, const CBLAS_UPLO uplo, const CBLAS_TRANSPOSE trans, const CBLAS_DIAG diag, const MKL_INT n, const double *a, const MKL_INT lda, double *x, const MKL_INT incx);
			r_cblas_strmv(CblasColMajor, CblasUpper, CblasNoTrans, CblasNonUnit, KNEW, cholXtX_prop, KNEW, GlobalMEMBuf_2nd, 1);
			//double cblas_ddot (const MKL_INT n, const double *x, const MKL_INT incx, const double *y, const MKL_INT incy);
			basis_prop->alpha2_star = yInfo.YtY - DOT(KNEW, GlobalMEMBuf_2nd, GlobalMEMBuf_2nd);
	*/

	/*---THE SECOND WAY-- */
	F32 alpha2_star        = (yInfo->YtY_plus_alpha2Q[0] - DOT(K, data->XtY, data->beta_mean)) * 0.5;

	//half_log_det_post  = sum(log(1. / diag(U)))	 
	//half_log_det_post  = -sum_log_diagv2(MODEL.prop.cholXtX, KNEW);
	F32 half_log_det_post = sum_log_diagv2(data->cholXtX, K);

	////Copy the diagonal of P_U to buf
	// vmsLn(KNEW, GlobalMEMBuf_1st, GlobalMEMBuf_1st, VML_HA);
	// ippsSum_32f(GlobalMEMBuf_1st, KNEW, &FLOAT_SHARE.half_log_det_post, ippAlgHintFast);
	// r_ippsSumLn_32f(GlobalMEMBuf_2nd, KNEW, &half_log_det_post);	

	//half_log_det_prior = -0.5 * (k_SN * log(prec(1)) + length(k_const_terms) * log(prec(2)) + length(linear_terms) * log(prec(3)));
	// F32 half_log_det_prior = -0.5f * KNEW * *modelPar.LOG_PREC[0]

	/***********************PrecPiorType=2*******************************/	 
	F32  half_log_det_prior = 0;
	for (I32 i = 0; i < model->nPrec; i++)
		half_log_det_prior += model->logPrecVec[i] * data->nTermsPerPrecGrp[i];
	half_log_det_prior *= -0.5;
	/***********************PrecPiorType=2*******************************/

	//log_ML = half_log_det_post - half_log_det_prior - (n / 2 + b) * log(a + a_star / 2);
	F32 marg_lik = half_log_det_post - half_log_det_prior -yInfo->alpha1_star * fastlog(alpha2_star);

	data->alpha2_star = alpha2_star;
	data->marg_lik   = marg_lik;
}



 //////////////////////////////////////////////////////////////////////

  

void MR_ComputeMargLik_prec01(BEAST2_MODELDATA_PTR data, BEAST2_MODEL_PTR model, BEAST2_YINFO_PTR yInfo,
								BEAST2_HyperPar_PTR hyperPard)
{
	I32 q = yInfo->q;
	I32 K = data->K;
	solve_U_as_LU_invdiag_sqrmat_multicols(data->cholXtX, data->XtY, data->beta_mean, K,q);

	 //MRBEAST
	F32PTR beta_mean = data->beta_mean;
	F32PTR XtY       = data->XtY;
	
	 //cblas_dgemm(CblasColMajor, CblasTrans, CblasNoTrans, k_newTerm, 1, N, 1, X_mars_prop + (k1_new - 1)*N, N, Y, N, 0, buff1, k_newTerm);
	r_cblas_sgemm(CblasColMajor, CblasTrans, CblasNoTrans, q, q, K, 1.f, beta_mean, K, XtY, K, 0.f, data->alphaQ_star, q);
	r_ippsSub_32f(data->alphaQ_star, yInfo->YtY_plus_alpha2Q,  data->alphaQ_star, q * q);
	//basis_prop->alpha_Q_star = yInfo.YtY_plus_Q - DOT(Knew, XtY_prop, beta_mean_prop);

	//half_log_det_post; = sum(log(1. / diag(U)))
	F32 half_log_det_post = sum_log_diagv2(data->cholXtX, K);

	 //half_log_det_prior = -0.5 * (k_SN * log(prec(1)) + length(k_const_terms) * log(prec(2)) + length(linear_terms) * log(prec(3)));	
	F32 half_log_det_prior = -0.5f * K * model->logPrecVal;
 
	/****************************************************************************************************************************/
	r_LAPACKE_spotrf(LAPACK_COL_MAJOR, 'U', q, data->alphaQ_star, q); // Choleskey decomposition; only the upper triagnle elements are used

 
	F32 sumLn_alphaQ_det = sum_log_diagv2(data->alphaQ_star, q);
 
	//log_ML = half_log_det_post - half_log_det_prior - (n / 2 + b) * log(a + a_star / 2);
	data->marg_lik = q*(half_log_det_post - half_log_det_prior) - yInfo->alpha1_star * sumLn_alphaQ_det*2.f; 	 

	//r_printf("Lik: det_post %f\n", f32_abs_sum(beta_mean, K * q));
	//r_printf("Lik: det_post %f\n", f32_sum_matrixdiag(data->cholXtX, K));
}



void SetUpPrecFunctions(I08 precPriorType, I32 q, PREC_FUNCS * funcs) {

	
	if (q == 1) {// for BEASTv4 
			if (  precPriorType == ConstPrec || precPriorType == UniformPrec) {
				funcs->GetXtXPrecDiag             = GetXtXPrecDiag_prec01;
				funcs->GetNumTermsPerPrecGrp      = GetNumTermsPerPrecGrp_prec012;
				funcs->UpdateXtXPrec_nTermsPerGrp = UpdateXtXPrec_nTermsPerGrp_prec01;
				funcs->chol_addCol                = chol_addCol_skipleadingzeros_prec_invdiag;
			}
			else if (precPriorType == ComponentWise)
			{
				funcs->GetXtXPrecDiag             = GetXtXPrecDiag_prec2;
				funcs->GetNumTermsPerPrecGrp      = GetNumTermsPerPrecGrp_prec012;
				funcs->UpdateXtXPrec_nTermsPerGrp = UpdateXtXPrec_nTermsPerGrp_prec2;
				funcs->chol_addCol                = chol_addCol_skipleadingzeros_precVec_invdiag;

			}
			else if (precPriorType == OrderWise )
			{

				funcs->GetXtXPrecDiag             = GetXtXPrecDiag_prec3;
				funcs->GetNumTermsPerPrecGrp      = GetNumTermsPerPrecGrp_prec3;
				funcs->UpdateXtXPrec_nTermsPerGrp = UpdateXtXPrec_nTermsPerGrp_prec3;
				funcs->chol_addCol                = chol_addCol_skipleadingzeros_precVec_invdiag;
		 
			}

			if      (precPriorType == 0)	funcs->IncreasePrecValues = IncreasePrecValues_prec0;
			else if (precPriorType == 1) 	funcs->IncreasePrecValues = IncreasePrecValues_prec1;
			else if (precPriorType == 2)	funcs->IncreasePrecValues = IncreasePrecValues_prec2;
			else if (precPriorType == 3)	funcs->IncreasePrecValues = IncreasePrecValues_prec3;

			if (precPriorType == 0)			funcs->ResamplePrecValues = ResamplePrecValues_prec0;
			else if (precPriorType == 1) 	funcs->ResamplePrecValues = ResamplePrecValues_prec1;
			else if (precPriorType == 2)	funcs->ResamplePrecValues = ResamplePrecValues_prec2;
			else if (precPriorType == 3)	funcs->ResamplePrecValues = ResamplePrecValues_prec3;

			if (precPriorType == 0)	        funcs->ComputeMargLik = ComputeMargLik_prec01;
			else if (precPriorType == 1) 	funcs->ComputeMargLik = ComputeMargLik_prec01;
			else if (precPriorType == 2)	funcs->ComputeMargLik = ComputeMargLik_prec2;
			else if (precPriorType == 3)	funcs->ComputeMargLik = ComputeMargLik_prec3;


	}

	if (q> 1) {// for BEASTv4 
			if (  precPriorType == ConstPrec || precPriorType == UniformPrec) {
				funcs->GetXtXPrecDiag             = GetXtXPrecDiag_prec01;
				funcs->GetNumTermsPerPrecGrp      = GetNumTermsPerPrecGrp_prec012;
				funcs->UpdateXtXPrec_nTermsPerGrp = UpdateXtXPrec_nTermsPerGrp_prec01;
				funcs->chol_addCol                = chol_addCol_skipleadingzeros_prec_invdiag;
			}
			else if (precPriorType == ComponentWise)
			{
				funcs->GetXtXPrecDiag             = GetXtXPrecDiag_prec2;
				funcs->GetNumTermsPerPrecGrp      = GetNumTermsPerPrecGrp_prec012;
				funcs->UpdateXtXPrec_nTermsPerGrp = UpdateXtXPrec_nTermsPerGrp_prec2;
				funcs->chol_addCol           = chol_addCol_skipleadingzeros_precVec_invdiag;

			}
			else if (precPriorType == OrderWise )
			{

				funcs->GetXtXPrecDiag             = GetXtXPrecDiag_prec3;
				funcs->GetNumTermsPerPrecGrp      = GetNumTermsPerPrecGrp_prec3;
				funcs->UpdateXtXPrec_nTermsPerGrp = UpdateXtXPrec_nTermsPerGrp_prec3;
				funcs->chol_addCol                = chol_addCol_skipleadingzeros_precVec_invdiag;
		 
			}

			if      (precPriorType == 0)	funcs->IncreasePrecValues = IncreasePrecValues_prec0;
			else if (precPriorType == 1) 	funcs->IncreasePrecValues = IncreasePrecValues_prec1;
			else if (precPriorType == 2)	funcs->IncreasePrecValues = IncreasePrecValues_prec2;
			else if (precPriorType == 3)	funcs->IncreasePrecValues = IncreasePrecValues_prec3;

			if (precPriorType == 0)			funcs->ResamplePrecValues = ResamplePrecValues_prec0;
			else if (precPriorType == 1) 	funcs->ResamplePrecValues = ResamplePrecValues_prec1;
			else if (precPriorType == 2)	funcs->ResamplePrecValues = ResamplePrecValues_prec2;
			else if (precPriorType == 3)	funcs->ResamplePrecValues = ResamplePrecValues_prec3;

			if (precPriorType == 0)	        funcs->ComputeMargLik = MR_ComputeMargLik_prec01;  // For MRBEAST
			else if (precPriorType == 1) 	funcs->ComputeMargLik = MR_ComputeMargLik_prec01;// ComputeMargLik_prec01;
			else if (precPriorType == 2)	funcs->ComputeMargLik = MR_ComputeMargLik_prec01; //ComputeMargLik_prec2;
			else if (precPriorType == 3)	funcs->ComputeMargLik = MR_ComputeMargLik_prec01; //ComputeMargLik_prec3;


	}
}

#include "abc_000_warning.h"
