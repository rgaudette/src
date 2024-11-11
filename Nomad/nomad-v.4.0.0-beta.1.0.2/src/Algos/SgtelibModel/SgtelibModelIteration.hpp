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
#ifndef __NOMAD400_SGTELIB_MODEL_ITERATION__
#define __NOMAD400_SGTELIB_MODEL_ITERATION__

#include "../../Algos/Iteration.hpp"
#include "../../Algos/SgtelibModel/SgtelibModelOptimize.hpp"

#include "../../nomad_nsbegin.hpp"

/// \class Iteration (Step)
class SgtelibModelIteration: public Iteration
{
private:
    // Optimizer for model on sgte function
    std::shared_ptr<SgtelibModelOptimize> _optimize;

public:
    /// Constructor
    /**
     \param parentStep         The parent of this step -- \b IN.
     \param k                  The iteration number -- \b IN.
     */
    explicit SgtelibModelIteration(const Step *parentStep,
                        const size_t k)
      : Iteration(parentStep, k),
        _optimize(nullptr)
    {
        init();
    }
    

    /// \brief Destructor
    /// When iteration is done, Flush prints output queue.
    virtual ~SgtelibModelIteration()
    {
        OutputQueue::Flush();
    }

    // Get/Set
    /// Return oracle points found by the Optimizer
    const EvalPointSet& getOraclePoints() const;


    virtual void startImp() override;
    virtual bool runImp() override;


private:
    void init();

};

#include "../../nomad_nsend.hpp"

#endif // __NOMAD400_SGTELIB_MODEL_ITERATION__
