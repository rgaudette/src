/*---------------------------------------------------------------------------------*/
/*  NOMAD - Nonlinear Optimization by Mesh Adaptive Direct Search -                */
/*                                                                                 */
/*  NOMAD - Version 4.0.0 has been created by                                      */
/*                 Viviane Rochon Montplaisir  - Polytechnique Montreal            */
/*                 Christophe Tribes           - Polytechnique Montreal            */
/*                                                                                 */
/*  The copyright of NOMAD - version 4.0.0 is owned by                             */
/*                 Sebastien Le Digabel        - Polytechnique Montreal            */
/*                 Viviane Rochon Montplaisir  - Polytechnique Montreal            */
/*                 Christophe Tribes           - Polytechnique Montreal            */
/*                                                                                 */
/*  NOMAD v4 has been funded by Rio Tinto, Hydro-Québec, NSERC (Natural Science    */
/*  and Engineering Research Council of Canada), INOVEE (Innovation en Energie     */
/*  Electrique and IVADO (The Institute for Data Valorization)                     */
/*                                                                                 */
/*  NOMAD v3 was created and developed by Charles Audet, Sebastien Le Digabel,     */
/*  Christophe Tribes and Viviane Rochon Montplaisir and was funded by AFOSR       */
/*  and Exxon Mobil.                                                               */
/*                                                                                 */
/*  NOMAD v1 and v2 were created and developed by Mark Abramson, Charles Audet,    */
/*  Gilles Couture, and John E. Dennis Jr., and were funded by AFOSR and           */
/*  Exxon Mobil.                                                                   */
/*                                                                                 */
/*  Contact information:                                                           */
/*    Polytechnique Montreal - GERAD                                               */
/*    C.P. 6079, Succ. Centre-ville, Montreal (Quebec) H3C 3A7 Canada              */
/*    e-mail: nomad@gerad.ca                                                       */
/*    phone : 1-514-340-6053 #6928                                                 */
/*    fax   : 1-514-340-5665                                                       */
/*                                                                                 */
/*  This program is free software: you can redistribute it and/or modify it        */
/*  under the terms of the GNU Lesser General Public License as published by       */
/*  the Free Software Foundation, either version 3 of the License, or (at your     */
/*  option) any later version.                                                     */
/*                                                                                 */
/*  This program is distributed in the hope that it will be useful, but WITHOUT    */
/*  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or          */
/*  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License    */
/*  for more details.                                                              */
/*                                                                                 */
/*  You should have received a copy of the GNU Lesser General Public License       */
/*  along with this program. If not, see <http://www.gnu.org/licenses/>.           */
/*                                                                                 */
/*  You can find information on the NOMAD software at www.gerad.ca/nomad           */
/*---------------------------------------------------------------------------------*/

#ifndef __NOMAD400_EVCINTERFACE__
#define __NOMAD400_EVCINTERFACE__

#include "../Algos/MainStep.hpp"
#include "../Algos/MeshBase.hpp"
#include "../Algos/Step.hpp"

#include "../Eval/EvaluatorControl.hpp"

#include "../nomad_nsbegin.hpp"


/// Class interface with EvaluatorControl, used by an Algorithm step through IterationUtils
/**
 \todo Complete documentation
 */
class EvcInterface
{
private:
    
    Step* _step; /// The step that uses the EvaluatorControl

    static std::shared_ptr<EvaluatorControl> _evaluatorControl; ///< Static EvaluatorControl
    
public:
    /// Constructor
    /**
     \param step            The step using this EvcInterface
     */
    explicit EvcInterface(Step* step )
      : _step(step )
    {
        init();
    }

    /*---------*/
    /* Get/Set */
    /*---------*/

    static const std::shared_ptr<EvaluatorControl> getEvaluatorControl()
    {
        return _evaluatorControl;
    }

    /**
     If the evaluatorControl attribute is NULL, throws an exception.
     */
    static void setEvaluatorControl(const std::shared_ptr<EvaluatorControl>& evaluatorControl);

    /// Interface for EvaluatorControl::setBarrier.
    /**
     Transform from subBarrier to fullBarrier, that is transform points in sub-space to full-space.
     Set the barrier to a full space barrier.
     */
    void setBarrier(const std::shared_ptr<Barrier>& subBarrier);
    
    /*---------------*/
    /* Other Methods */
    /*-------------- */
    
    // This method may be used by MegaIteration, or by a SearchMethod or by Poll
    /**
     *  For each point, look if it is in the cache.
     *  If it is, count a cache hit.
     *  If not, convert it to an EvalQueuePoint and add it to EvaluatorControl's Queue.
     
     \param trialPoints The trial points -- \b IN/OUT.
     \param useMesh     Flag to use mesh or not -- \b IN.
     */
    void keepPointsThatNeedEval(const EvalPointSet &trialPoints, bool useMesh = true);


    /**
     When points are generated and added to queue, we can start evaluation.
     */
    SuccessType startEvaluation();

    /// Evaluate a single point.
    /**
     Useful for X0. \n
     This method will convert a point from subspace to full space
     before calling EvaluatorControl's method of the same name.
     
     \param evalPoint  The poin to evaluate -- \b IN/OUT.
     \param hMax       The max infeasibility for keeping points in barrier -- \b IN.
     \return           \c true if evaluation worked (evalOk), \c false otherwise.
    */
    bool evalSinglePoint(EvalPoint &evalPoint, const Double &hMax = INF);

private:
    /// Helper for constructor
    void init();

    /// Helper for init
    /**
     Utility that throws an exception when not verified.
     */
    void verifyStepNotNull();
    
    /// Helper for init and setEvaluatorControl
    /**
     Utility that throws an exception when not verified.
     */
    static void verifyEvaluatorControlNotNull();

};

#include "../nomad_nsend.hpp"

#endif // __NOMAD400_EVCINTERFACE__
