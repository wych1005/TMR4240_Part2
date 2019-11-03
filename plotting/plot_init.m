% close all
t = (logsout{1}.Values.Time);

eta = logsout.get('eta').Values;
eta_hat = logsout.get('eta_hat').Values;
eta_ref = logsout.get('eta_ref').Values;

nu = logsout.get('nu').Values;
nu_hat = logsout.get('nu_hat').Values;
nu_ref = logsout.get('nu_ref').Values;

tau_d = logsout.get('tau_d').Values;
tau_alloc = logsout.get('tau_alloc').Values;
tau_thr = logsout.get('tau_thr').Values;

u_thr = logsout.get('u_thr').Values;
alpha_thr = logsout.get('alpha_thr').Values;
alpha_thr_wrap = logsout.get('alpha_thr_wrap').Values;

